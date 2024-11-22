import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path_provider/path_provider.dart';

import '/logger.dart';
import '/services/clipboard_service.dart';

part 'webserver_service.g.dart';

@Riverpod(keepAlive: true)
class ReceiveProgress extends _$ReceiveProgress {
  @override
  double build() {
    return 0.0;
  }

  void set(double progress) {
    state = progress;
  }
}

@riverpod
class UploadInProgress extends _$UploadInProgress {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
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
      return handleClipboard(request, ref);
    } else if (request.url.path == 'upload') {
      return handleUpload(request, ref);
    }
  }
  return Response.notFound('Not Found');
}

Future<Response> handleClipboard(Request request, Ref ref) async {
  final clipboardService = ref.watch(clipboardServiceProvider.notifier);

  if (request.method == 'POST') {
    // set the local clipboard to the received clipboard text
    Map payload = jsonDecode(await request.readAsString());
    clipboardService.set(payload['text']);
    return Response.ok('Clipboard received');
  }
  return Response.notFound('Not Found');
}

Future<Response> handleUpload(Request request, Ref ref) async {
  final uploadInProgress = ref.watch(uploadInProgressProvider);
  final uploadInProgressNotifier = ref.read(uploadInProgressProvider.notifier);
  final receiveProgress = ref.read(receiveProgressProvider.notifier);

// Check if an upload is already in progress
  if (uploadInProgress) {
    return Response(
      429,
      body: 'Another upload is currently in progress. Please wait and try again.',
    );
  }

  // Set the uploadInProgress flag to true
  uploadInProgressNotifier.set(true);

  try {
    // save the uploaded file to the app's documents directory
    final contentType = request.headers['content-type'];
    if (contentType != null && contentType.startsWith('multipart/form-data')) {
      // parse the multipart request
      final boundary = contentType.split('boundary=')[1];
      final transformer = MimeMultipartTransformer(boundary);

      // Get total content length
      final contentLength = int.tryParse(request.headers['content-length'] ?? '0') ?? 0;
      int bytesReceived = 0;

      // Monitor the request body stream
      final monitoredStream = request.read().transform(
        StreamTransformer<Uint8List, Uint8List>.fromHandlers(
          handleData: (Uint8List data, EventSink<Uint8List> sink) {
            bytesReceived += data.length;
            // Update the progress
            double progress = bytesReceived / contentLength;
            receiveProgress.set(progress);
            sink.add(data);
          },
        ),
      );

      final parts = await transformer.bind(monitoredStream).toList();

      for (var part in parts) {
        final contentDisposition = part.headers['content-disposition']!;
        final filename = RegExp(r'filename="(.+)"').firstMatch(contentDisposition)!.group(1);
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');

        // Collect the data from the part
        final content = await part.fold<Uint8List>(
          Uint8List(0),
          (previous, element) => Uint8List.fromList([...previous, ...element]),
        );

        await file.writeAsBytes(content);
        logger.i('File saved: ${file.path}');
      }
      receiveProgress.set(1.0);
      return Response.ok('File uploaded');
    } else {
      return Response(400, body: 'Invalid content type');
    }
  } finally {
    // Set the uploadInProgress flag to false
    uploadInProgressNotifier.set(false);
  }
}
