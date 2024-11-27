import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/models/generic_providers.dart';
import '/styles/decorations.dart';
import '/widgets/platform_icon_widget.dart';
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
    final useDarkTheme = ref.watch(togglerProvider('darkTheme'));

    if (!clients.containsKey(client.id)) {
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
        title: Text(client.name),
      ),
      body: Container(
        decoration: fancyBackground(useDarkTheme),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   boxShadow: const [
        //     BoxShadow(
        //       color: Colors.black12,
        //       blurRadius: 1.0,
        //       spreadRadius: 1.0,
        //       offset: Offset(5.0, 5.0),
        //     ),
        //   ],
        // ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlatformIcon(platform: client.platform!),
              Text(client.name),
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
