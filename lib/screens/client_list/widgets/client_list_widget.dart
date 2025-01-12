import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:open_file/open_file.dart';

import '/services/webserver_service.dart';
import '/models/client_provider.dart';
import '/widgets/platform_icon_widget.dart';
import '../client_screen.dart';

import '/utils/logger.dart';

/// List of clients discovered by the Bonjour service
class ClientList extends ConsumerWidget {
  const ClientList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building ClientList');

    final clients = ref.watch(duktiClientsProvider);

    final clientsList = clients.entries.toList()
      ..sort(
        (a, b) => a.value.name.compareTo(b.value.name),
      );

    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: ImplicitlyAnimatedList<MapEntry<String, DuktiClient>>(
          shrinkWrap: true,
          items: clientsList,
          areItemsTheSame: (a, b) => a.key == b.key,
          itemBuilder: (context, animation, entry, index) {
            final client = entry.value;
            final textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black;

            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: brightness == Brightness.light ? Colors.white : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 1.0,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    child: ClientListTile(client: client, textColor: textColor),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ClientListTile extends StatelessWidget {
  const ClientListTile({
    super.key,
    required this.client,
    required this.textColor,
  });

  final DuktiClient client;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Open client',
      child: ListTile(
        leading: client.platform != null
            ? PlatformIcon(platform: client.platform!)
            : SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                  color: textColor,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              overflow: TextOverflow.ellipsis,
              TextSpan(
                children: client.ip != null
                    ? [
                        TextSpan(
                          text: client.ip,
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
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
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: UploadList(
                client: client,
              ),
            )
          ],
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
    );
  }
}

class UploadList extends ConsumerWidget {
  final DuktiClient client;
  const UploadList({super.key, required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadProgress = ref.watch(uploadProgressProvider);
    final uploads = uploadProgress[client.id];
    if (uploads == null) {
      return SizedBox.shrink();
    }
    // logger.e(uploads);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: uploads.values.map((upload) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Tooltip(
                  message: 'Open file',
                  child: GestureDetector(
                    onTap: () async {
                      await OpenFile.open(upload.filePath);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(12),
                            value: upload.progress,
                            color: Colors.green,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 12),
                              upload.fileName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        IconButton(
          tooltip: 'Clear uploads',
          onPressed: () async {
            ref.read(uploadProgressProvider.notifier).clear(client.id);
          },
          icon: const Icon(Icons.clear),
        ),
      ],
    );
  }
}
