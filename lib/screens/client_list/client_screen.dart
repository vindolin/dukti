import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markup_text/markup_text.dart';

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
    final clients = ref.read(duktiClientsProvider);

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

    final hostInfoStyle = TextStyle(fontSize: 24);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(client.name),
      ),
      body: Container(
        decoration: fancyBackground(Theme.of(context).brightness == Brightness.dark),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        PlatformIcon(platform: client.platform!),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            client.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    MarkupText(
                      '(b)ID(/b): ${client.id}',
                      style: hostInfoStyle,
                    ),
                    Text.rich(
                      overflow: TextOverflow.ellipsis, // can't do this with MarkupText
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Host: ',
                            style: hostInfoStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: client.host,
                            style: hostInfoStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MarkupText(
                        '(b)IP(/b): ${client.ip}\n'
                        '(b)Port(/b): ${client.port}',
                        style: hostInfoStyle.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: FilledButton(
                            onPressed: () async {
                              await sendClipboard(client);
                            },
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.paste),
                                SizedBox(width: 8),
                                const Text('Send clipboard text'),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: UploadButton(client: client),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       UploadWidget(client: client),
      //       IconButton(
      //         onPressed: () async {
      //           await sendClipboard(client);
      //         },
      //         icon: const Icon(Icons.paste),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
