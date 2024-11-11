// ignore_for_file: avoid_print
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:path_provider/path_provider.dart';

import 'screens/home_screen.dart';
import 'services/bonjour_service.dart' as bonsoir_service;
import 'services/server_port_service.dart';
// import 'services/socket_service.dart' as socket_service;
import 'models/client_name.dart';

import '/logger.dart';

/*
  Hot reload sadly does not work with the bonsoir plugin
  When hot reload is triggered, the old bonsoir broadcast is not stopped
  and the old device is still being broadcasted.
  see: https://stackoverflow.com/questions/69952232/handling-dispose-method-when-using-hot-restart
*/

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
          print('File saved: ${file.path}');
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

void main() async {
  await getPort();
  logger.e('Using port $serverPort');
  await startServer(serverPort!);
  await initClientName();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: DuktiApp(),
    ),
  );
}

class DuktiApp extends ConsumerWidget {
  const DuktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building DuktiApp');

    ref.watch(bonsoir_service.eventsProvider); // start listening to events
    ref.watch(bonsoir_service.startBroadcastProvider); // broadcasting our dukti service
    // final socketEventStream = ref.watch(socket_service.socketEventsProvider);
    // logger.e(socketEventStream.value?.data);

    // startServer(ref);

    return MaterialApp(
      title: 'Dukti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DuktiHome(title: 'Dukti!'),
    );
  }
}
