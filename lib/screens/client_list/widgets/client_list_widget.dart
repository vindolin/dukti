import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_list_plus/animated_list_plus.dart';

import '/models/client_provider.dart';
import '../client_screen.dart';
import '/widgets/platform_icon_widget.dart';

// import '/logger.dart';

class ClientList extends ConsumerWidget {
  const ClientList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(duktiClientsProvider);

    final clientsList = clients.entries.toList()
      ..sort(
        (a, b) => a.value.name.compareTo(b.value.name),
      );

    return ImplicitlyAnimatedList<MapEntry<String, DuktiClient>>(
      items: clientsList,
      areItemsTheSame: (a, b) => a.key == b.key,
      itemBuilder: (context, animation, entry, index) {
        final client = entry.value;

        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOut,
          animation: animation,
          child: Column(
            children: [
              ListTile(
                leading: client.platform != null
                    ? PlatformIcon(platform: client.platform!)
                    : SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        text: client.name,
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        text: ' ${client.id}',
                      ),
                    ],
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    children: client.ip != null
                        ? [
                            TextSpan(
                              text: client.ip,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ':${client.port}',
                              style: const TextStyle(color: Colors.green),
                            ),
                            TextSpan(
                              text: ' (${client.host})',
                              style: const TextStyle(color: Colors.grey),
                            )
                          ]
                        : [
                            const TextSpan(
                              text: 'resolving...',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                  ),
                ),
                onTap: client.ip != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientScreen(client: client),
                          ),
                        );
                      }
                    : null,
              ),
              const Divider(height: 0),
            ],
          ),
        );
      },
    );
  }
}
