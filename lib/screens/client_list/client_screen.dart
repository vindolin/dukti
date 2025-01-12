import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markup_text/markup_text.dart';

import '/styles/decorations.dart';
import '/models/client_provider.dart';
import '/services/clipboard_service.dart';
import '/widgets/app_bar_widget.dart';
import '/widgets/platform_icon_widget.dart';
import '/widgets/upload_widget.dart';

import '/utils/logger.dart';

class ClientScreen extends ConsumerWidget {
  final DuktiClient client;

  const ClientScreen({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building ClientScreen');
    final clientInList = ref.watch(duktiClientsProvider.select((value) => value[client.id]));

    if (clientInList == null) {
      return Scaffold(
        appBar: DuktiAppBar(),
        body: Center(
          child: Text('Client not found'),
        ),
      );
    }

    final hostInfoStyle = TextStyle(fontSize: 24);

    return Scaffold(
      appBar: DuktiAppBar(),
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
                    /// The client's platform icon and name.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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

                    /// Client information, including the platform icon, name, ID, host, IP, and port.
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

                          /// Button to send the clipboard text to the client.
                          child: FilledButton(
                            onPressed: () async {
                              try {
                                await sendClipboard(client);
                              } on EmptyClipboardException catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('The clipboard is empty'),
                                  ));
                                }
                              } on ClipboardException catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Failed to send clipboard'),
                                  ));
                                }
                              }
                            },
                            child: Row(
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

                          /// Button to send a file to the client.
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
    );
  }
}
