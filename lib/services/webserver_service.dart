import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path_provider/path_provider.dart';

import '../utils/logger.dart';
import '/services/clipboard_service.dart';

part 'webserver_service.g.dart';

class Upload {
  final String filename;
  final int contentLength;
  final String clientId;
  int bytesReceived = 0;
  double progress = 0.0;
  bool abortFlag = false;

  Upload({
    required this.filename,
    required this.contentLength,
    required this.clientId,
  });
}

//TODO allow the same file to be uploaded only once

@Riverpod(keepAlive: true)
class UploadProgress extends _$UploadProgress {
  @override
  Map<String, Upload> build() {
    return {};
  }

  void add(String filename, Upload upload) {
    state = Map.from(state)..[filename] = upload;
  }

  void remove(String filename) {
    state = Map.from(state)..remove(filename);
  }

  void clear() {
    state = {};
  }
}

@riverpod
Future<void> startWebServer(Ref ref, int port) async {
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(
        (request) => _handleRequest(request, ref),
      );

  final server = await shelf_io.serve(handler, '0.0.0.0', port);
  logger.i('Server listening on port ${server.port}');

  // Dispose the server when the provider is destroyed
  ref.onDispose(() {
    server.close();
    logger.i('Server closed');
  });
}

Future<Response> _handleRequest(Request request, Ref ref) async {
  if (request.method == 'POST') {
    // both upload and clipboard requests are POST requests

    if (request.url.path == 'clipboard') {
      return _handleClipboard(request, ref);
    } else if (request.url.path == 'upload') {
      return _receiveUpload(request, ref);
    }
  }
  return Response.notFound('Not Found');
}

Future<Response> _handleClipboard(Request request, Ref ref) async {
  final clipboardService = ref.watch(clipboardServiceProvider.notifier);

  if (request.method == 'POST') {
    // set the local clipboard to the received clipboard text
    Map payload = jsonDecode(await request.readAsString());
    clipboardService.set(payload['text']);
    return Response.ok('Clipboard received');
  }
  return Response.notFound('Not Found');
}

Future<Response> _receiveUpload(Request request, Ref ref) async {
  try {
    final contentType = request.headers['content-type'];

    if (contentType != null && contentType.startsWith('multipart/form-data')) {
      // Extract boundary from content type
      final boundary = contentType.split('boundary=')[1];
      final transformer = MimeMultipartTransformer(boundary);

      // Parse the multipart request
      final parts = transformer.bind(request.read());

      // Get content length for progress tracking
      final contentLength = int.tryParse(request.headers['content-length'] ?? '0') ?? 0;
      int bytesReceived = 0;
      final uploadProgress = ref.watch(uploadProgressProvider.notifier);

      String? clientId;

      // Process each part
      await for (final part in parts) {
        // Get content disposition
        final contentDisposition = part.headers['content-disposition']!;
        final nameMatch = RegExp(r'name="([^"]*)"').firstMatch(contentDisposition);
        final fieldName = nameMatch?.group(1);

        if (fieldName == 'file') {
          // This part is the file
          final filenameMatch = RegExp(r'filename="([^"]*)"').firstMatch(contentDisposition);
          final filename = filenameMatch != null ? filenameMatch.group(1) : 'uploaded_file';

          // Create file to write to
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$filename');
          final fileSink = file.openWrite();

          // Create an Upload object and add it to UploadProgressList
          final upload = Upload(
            clientId: clientId!,
            filename: filename!,
            contentLength: contentLength,
          );

          try {
            // Write data chunks directly to the file
            await for (final data in part) {
              bytesReceived += data.length;
              fileSink.add(data);

              // Update progress
              double progress = bytesReceived / contentLength;
              upload.progress = progress;

              // Update the Upload object in the list
              uploadProgress.add(filename, upload);
              logger.i('Upload progress for $filename: $progress');
            }

            upload.progress = 1.0;
            uploadProgress.add(filename, upload);

            await fileSink.close();
            logger.i('File saved: ${file.path}');
          } catch (e) {
            // Delete the partially downloaded file if an error occurs
            if (await file.exists()) {
              await file.delete();
              logger.i('Partial file deleted due to error: $e');
            }
            rethrow;
          }
        } else if (fieldName == 'clientId') {
          // This part is the clientId
          final content = await utf8.decoder.bind(part).join();
          clientId = content.trim();
          logger.e('Received clientId: $clientId');
        } else {
          // Handle other form fields if necessary
        }
      }

      return Response.ok('File uploaded');
    } else {
      return Response(400, body: 'Invalid content type');
    }
  } catch (e) {
    logger.e('Error receiving upload: $e');
    return Response.internalServerError(body: 'Error receiving upload');
  }
}
