import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/models/client_provider.dart';
import '/widgets/upload_widget.dart';
import '/services/clipboard_service.dart';

class ClientScreen extends ConsumerWidget {
  final DuktiClient client;

  const ClientScreen({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(duktiClientsProvider);

    if (!clients.containsKey(client.name)) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Client ${client.name}'),
        ),
        body: Center(
          child: Text('Client not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Client ${client.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Client: ${client.name}'),
              Text('ID: ${client.id}'),
              Text(
                'Host: ${client.host}',
                overflow: TextOverflow.ellipsis,
              ),
              Text('IP: ${client.ip}'),
              Text('Port: ${client.port}'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UploadWidget(client: client),
            IconButton(
              onPressed: () async {
                await sendClipboard(client);
              },
              icon: const Icon(Icons.paste),
            ),
          ],
        ),
      ),
    );
  }
}
