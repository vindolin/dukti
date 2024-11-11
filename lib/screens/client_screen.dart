import 'package:flutter/material.dart';

// import '/models/client_name.dart';
import '/models/client_provider.dart';
import '/widgets/upload_widget.dart';

uploadFile(String ip, int port) async {}

sendClipboard(DuktiClient client) async {}

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
        title: Text('Client ${client.name}'),
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
            UploadWidget(client: client),
            IconButton(
              onPressed: () async {
                sendClipboard(client);
              },
              icon: const Icon(Icons.paste),
            ),
          ],
        ),
      ),
    );
  }
}
