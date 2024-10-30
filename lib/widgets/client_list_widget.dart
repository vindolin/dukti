import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/services/bonjour_service.dart' as bonsoir_service;
import '/screens/client_screen.dart';
import '/widgets/platform_icon_widget.dart';

class ClientList extends ConsumerWidget {
  const ClientList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients =
        ref.watch(bonsoir_service.duktiClientsProvider); // clients are dependent on the events provider further up

    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final entry = clients.entries.elementAt(index);
        final name = entry.key;
        final client = entry.value;

        return ListTile(
          leading: PlatformIcon(platform: client.platform),
          title: Text(entry.key),
          subtitle: RichText(
              text: TextSpan(
            children: [
              TextSpan(text: client.ip, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(text: ' (${client.host})', style: const TextStyle(color: Colors.grey)),
            ],
          )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientScreen(name: name, address: client.host, ip: client.ip),
              ),
            );
          },
        );
      },
    );
  }
}
