import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import '/logger.dart';
import '../models/client_provider.dart';
import '../services/bonjour_service.dart';
import '../services/bonjour_service.dart' show clientName;

sendToServer(String ip, int port) {
  final uri = 'http://$ip:$port';
  logger.i(uri);
  socket_io.Socket socket = socket_io.io(uri, socket_io.OptionBuilder().setTransports(['websocket']).build());
  socket.onConnect((_) {
    logger.i('connect');
    socket.emit('msg', clientName);
    // socket.disconnect();
  });
  socket.on('event', (data) => logger.i(data));
  socket.onDisconnect((_) => logger.i('disconnect'));
  socket.on('fromServer', (_) => logger.i(_));
}

class ClientScreen extends StatelessWidget {
  final Client client;

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
            Text('port: ${client.port}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await Clipboard.getData('text/plain').then((value) {
          //   // open a socket to $ip and transfer the value
          // });
          sendToServer(client.ip, client.port);
        },
        tooltip: 'paste',
        child: const Icon(Icons.paste),
      ),
    );
  }
}
