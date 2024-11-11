import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:file_picker/file_picker.dart';

import '/logger.dart';
// import '/models/client_name.dart';
import '/models/client_provider.dart';

uploadFile(String ip, int port) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    final file = File(result.files.single.path!);
    logger.i(file);

    socket_io.Socket socket = socket_io.io(
      'http://$ip:$port/upload',
      socket_io.OptionBuilder().setTransports(['websocket']).build(),
    );
    socket.onConnect((_) {
      logger.i('connect');
      socket.emitWithBinary('upload', file.readAsBytesSync());
    });
    socket.onDisconnect((_) => logger.i('disconnect'));
  } else {
    logger.i('No file selected');
  }
}

sendClipboard(String ip, int port) async {
  final clipboardData = await Clipboard.getData('text/plain');
  logger.i('Clipboard data: ${clipboardData?.text}');

  socket_io.Socket socket = socket_io.io(
    'http://$ip:$port/clipboard',
    socket_io.OptionBuilder().setTransports(['websocket']).build(),
  );
  socket.onConnect((_) {
    logger.i('connect');
    socket.emit('clipboard', clipboardData?.text);
  });
  socket.onDisconnect((_) => logger.i('disconnect'));
}

// sendFile(String) {}

class ClientScreen extends StatelessWidget {
  final DuktiClient client;

  const ClientScreen({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    // connectSocket();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Client: ${client.name}'),
            Text('Host: ${client.host}'),
            Text('IP: ${client.ip}'),
            Text('Port: ${client.port}'),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () async {
                uploadFile(client.ip, client.port);
              },
              icon: const Icon(Icons.upload),
            ),
            IconButton(
              onPressed: () async {
                sendClipboard(client.ip, client.port);
              },
              icon: const Icon(Icons.paste),
            ),
          ],
        ),
      ),
    );
  }
}
