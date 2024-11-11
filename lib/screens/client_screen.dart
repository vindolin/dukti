import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// import '/models/client_name.dart';
import '/models/client_provider.dart';

uploadFile(String ip, int port) async {}

sendClipboard(String ip, int port) async {}

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
