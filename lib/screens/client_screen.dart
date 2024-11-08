import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '/logger.dart';
// import '/models/client_name.dart';
import '/models/client_provider.dart';

Future<ClipboardData?> getData(String format) async {
  final Map<String, dynamic>? result = await SystemChannels.platform.invokeMethod(
    'Clipboard.getData',
    format,
  );
  if (result == null) {
    return null;
  }
  return ClipboardData(text: result['text'] as String);
}

sendClipboard(String ip, int port) async {
  final clipboardData = await getData('text/plain');
  logger.i('Clipboard data: ${clipboardData?.text}');

  socket_io.Socket socket = socket_io.io(
    'http://$ip:$port/clipboard',
    socket_io.OptionBuilder().setTransports(['websocket']).build(),
  );
  socket.onConnect((_) {
    logger.i('connect');
    socket.emit('msg', clipboardData?.text);
  });
  socket.on('event', (data) => logger.i(data));
  socket.onDisconnect((_) => logger.i('disconnect'));
  socket.on('fromServer', (_) => logger.i(_));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await Clipboard.getData('text/plain').then((value) {
          //   // open a socket to $ip and transfer the value
          // });
          sendClipboard(client.ip, client.port);
        },
        tooltip: 'paste',
        child: const Icon(Icons.paste),
      ),
    );
  }
}
