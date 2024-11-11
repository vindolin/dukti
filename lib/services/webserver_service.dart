import 'dart:io';

import 'package:mime/mime.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path_provider/path_provider.dart';

import '/logger.dart';

startServer(int port) async {
  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(_handleRequest);
  final server = await shelf_io.serve(handler, '0.0.0.0', port);
  logger.i('Server listening on port ${server.port}');
}

Future<Response> _handleRequest(Request request) async {
  if (request.method == 'POST') {
    if (request.url.path == 'upload') {
      final contentType = request.headers['content-type'];
      if (contentType != null && contentType.startsWith('multipart/form-data')) {
        final boundary = contentType.split('boundary=')[1];
        final transformer = MimeMultipartTransformer(boundary);
        final bodyStream = request.read();
        final parts = await transformer.bind(bodyStream).toList();

        for (var part in parts) {
          final contentDisposition = part.headers['content-disposition']!;
          final filename = RegExp(r'filename="(.+)"').firstMatch(contentDisposition)!.group(1);
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/$filename');
          await file.writeAsBytes(await part.toList().then((data) => data.expand((x) => x).toList()));
          logger.i('File saved: ${file.path}');
        }
        return Response.ok('File uploaded');
      } else {
        return Response(400, body: 'Invalid content type');
      }
    } else if (request.url.path == 'clipboard') {
      final body = await request.readAsString();
      logger.e('Clipboard: $body');
      return Response.ok('Clipboard received');
    }
  }
  return Response.notFound('Not Found');
}
