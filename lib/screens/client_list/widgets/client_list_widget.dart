import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_list_plus/animated_list_plus.dart';

import '/services/webserver_service.dart';
import '/models/client_provider.dart';
import '/models/generic_providers.dart';
import '/widgets/platform_icon_widget.dart';
import '/utils/blendmask.dart';
import '../client_screen.dart';

import '/utils/logger.dart';

class ClientList extends ConsumerWidget {
  const ClientList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building ClientList');

    final clients = ref.watch(duktiClientsProvider);
    final useDarkTheme = ref.watch(togglerProvider('darkTheme'));

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
            final textColor = useDarkTheme ? Colors.white70 : Colors.black;

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
                  // const Divider(height: 0),
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
    return ListTile(
      leading: client.platform != null
          ? PlatformIcon(platform: client.platform!)
          : SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
      title: RichText(
        text: TextSpan(
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
          RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
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
    );
  }
}

class UploadList extends ConsumerWidget {
  final DuktiClient client;
  const UploadList({super.key, required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final uploadProgress = ref.watch(uploadProgressProvider.select((state) => state[client.id]));
    final uploadProgress = ref.watch(uploadProgressProvider);
    final uploads = uploadProgress[client.id];
    if (uploads == null) {
      return const Text('---');
    }
    logger.e(uploads);

    return Column(
      children: uploads.values.map((upload) {
        final fileName = upload.filename;
        final progress = upload.progress;

        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Stack(
            children: [
              SizedBox(
                height: 24,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(4),
                  value: progress / 2,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: BlendMask(
                    blendMode: BlendMode.exclusion,
                    child: Text(
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      fileName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
