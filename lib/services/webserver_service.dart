import 'dart:convert';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path_provider/path_provider.dart';

import '/logger.dart';
import '/services/clipboard_service.dart';

part 'webserver_service.g.dart';

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
  final clipboardService = ref.watch(clipboardServiceProvider.notifier);

  if (request.method == 'POST') {
    // both upload and clipboard requests are POST requests
    if (request.url.path == 'upload') {
      // save the uploaded file to the app's documents directory
      final contentType = request.headers['content-type'];
      if (contentType != null && contentType.startsWith('multipart/form-data')) {
        // parse the multipart request
        final boundary = contentType.split('boundary=')[1];
        final transformer = MimeMultipartTransformer(boundary);
        final bodyStream = request.read();
        final parts = await transformer.bind(bodyStream).toList();

        for (var part in parts) {
          final contentDisposition = part.headers['content-disposition']!;
          final filename = RegExp(r'filename="(.+)"').firstMatch(contentDisposition)!.group(1);
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$filename');
          await file.writeAsBytes(
            await part.toList().then(
                  (data) => data.expand((x) => x).toList(),
                ),
          );
          logger.i('File saved: ${file.path}');
        }
        return Response.ok('File uploaded');
      } else {
        return Response(400, body: 'Invalid content type');
      }
    } else if (request.url.path == 'clipboard') {
      // set the local clipboard to the received clipboard text
      Map payload = jsonDecode(await request.readAsString());
      clipboardService.set(payload['text']);
      return Response.ok('Clipboard received');
    }
  }
  return Response.notFound('Not Found');
}
