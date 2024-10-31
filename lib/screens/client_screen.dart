import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/client_provider.dart';
// import 'package:socket_io/socket_io.dart';

// connectSocket() {
//   // Dart client
//   IO.Socket socket = IO.io('http://localhost:3000');
//   socket.onConnect((_) {
//     print('connect');
//     socket.emit('msg', 'test');
//   });
//   socket.on('event', (data) => print(data));
//   socket.onDisconnect((_) => print('disconnect'));
//   socket.on('fromServer', (_) => print(_));
// }

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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Clipboard.getData('text/plain').then((value) {
            // open a socket to $ip and transfer the value
          });
        },
        tooltip: 'paste',
        child: const Icon(Icons.paste),
      ),
    );
  }
}
