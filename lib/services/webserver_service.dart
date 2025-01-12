import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path_provider/path_provider.dart';

import '/globals.dart' show snackbarKey;
import '/services/clipboard_service.dart';

import '../utils/logger.dart';

part 'webserver_service.g.dart';

late final Directory downloadDirectory;

class Upload {
  final int fileId;
  final String fileName;
  final String filePath;
  final int contentLength;
  final String clientId;
  int bytesReceived = 0;
  double progress = 0.0;
  bool abortFlag = false;

  Upload({
    required this.fileId,
    required this.fileName,
    required this.filePath,
    required this.contentLength,
    required this.clientId,
  });
}

@Riverpod(keepAlive: true)
class UploadProgress extends _$UploadProgress {
  @override
  Map<String, Map<int, Upload>?> build() {
    return {};
  }

  void add(String clientId, Upload upload) {
    state.putIfAbsent(clientId, () => {});
    state[clientId]![upload.fileId] = upload;
    state = Map.from(state);
  }

  void clear(clientId) {
    state = Map.from(state)..remove(clientId);
  }
}

@riverpod
Future<void> startWebServer(Ref ref, int port) async {
  final certData = await rootBundle.load('assets/certificate/cert.pem');
  final keyData = await rootBundle.load('assets/certificate/key.pem');
  final securityContext = SecurityContext.defaultContext;
  securityContext.useCertificateChainBytes(certData.buffer.asUint8List());
  securityContext.usePrivateKeyBytes(keyData.buffer.asUint8List());

  if (Platform.operatingSystem == 'android') {
    downloadDirectory = Directory('/storage/emulated/0/Download');
  } else {
    downloadDirectory = await getApplicationDocumentsDirectory();
  }

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(
        (request) => _handleRequest(request, ref),
      );

  final server = await shelf_io.serve(handler, '0.0.0.0', port, securityContext: securityContext);
  logger.i('Server listening on port ${server.port}');

  // Dispose the server when the provider is destroyed
  ref.onDispose(() {
    server.close();
    logger.i('Server closed');
  });
}

/// Handles incoming requests
Future<Response> _handleRequest(Request request, Ref ref) async {
  if (request.method == 'POST') {
    // both upload and clipboard requests are POST requests

    if (request.url.path == 'clipboard') {
      // delegate clipboard requests to the clipboard service
      return _handleClipboard(request, ref);
    } else if (request.url.path == 'upload') {
      // delegate upload requests to the upload handler
      return _receiveUpload(request, ref);
    }
  }
  return Response.notFound('Not Found');
}

/// Handles incoming clipboard requests
Future<Response> _handleClipboard(Request request, Ref ref) async {
  if (request.method == 'POST') {
    // set the local clipboard to the received clipboard text
    Map payload = jsonDecode(await request.readAsString());
    ref.read(clipboardServiceProvider.notifier).set(payload['text']);
    return Response.ok('Clipboard received');
  }
  return Response.notFound('Not Found');
}

int fileId = 0;

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

        if (fieldName == 'clientId') {
          // This part is the clientId
          final content = await utf8.decoder.bind(part).join();
          clientId = content.trim();
          logger.e('Received clientId: $clientId');
        } else if (fieldName == 'file') {
          // This part is the file
          final filenameMatch = RegExp(r'filename="([^"]*)"').firstMatch(contentDisposition);
          final filename = filenameMatch != null ? filenameMatch.group(1) : 'uploaded_file';

          await Permission.manageExternalStorage.request();

          // Create file to write to
          logger.i('Saving file to: ${downloadDirectory.path}/$filename');
          final file = File('${downloadDirectory.path}/$filename');
          final fileSink = file.openWrite();

          // Create an Upload object and add it to UploadProgressList
          final upload = Upload(
            fileId: fileId++,
            clientId: clientId!,
            fileName: filename!,
            filePath: file.path,
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
              uploadProgress.add(clientId, upload);
              logger.i('Upload progress for $filename: $progress');
            }

            upload.progress = 1.0;
            uploadProgress.add(clientId, upload);

            await fileSink.close();
            snackbarKey.currentState?.showSnackBar(
              SnackBar(content: Text('File saved: ${file.path}')),
            );
            logger.i('File saved: ${file.path}');
          } catch (e) {
            // Delete the partially downloaded file if an error occurs
            logger.i('Deleting Partial file due to error: $e');
            if (await file.exists()) {
              await file.delete();
            }
            rethrow;
          }
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
