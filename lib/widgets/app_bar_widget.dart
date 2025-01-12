import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/models/client_name.dart';
import '/services/bonjour_service.dart';

class DuktiAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DuktiAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBroadcasting = ref.watch(isBroadcastingProvider);

    /// AppBar that shows the client name and ID
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text.rich(
        TextSpan(
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          children: [
            TextSpan(
              text: clientName, //🖥️
            ),
            TextSpan(
              text: ' $clientId',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Icon(isBroadcasting ? Icons.wifi : Icons.wifi_off),
        SizedBox(width: 4),
        SizedBox(
          width: 64,
          height: 32,
          child: FittedBox(
            /// Switch to toggle the broadcasting
            child: Switch(
              value: isBroadcasting,
              onChanged: (value) {
                ref.watch(isBroadcastingProvider.notifier).set(value);
                value ? startBroadcast() : stopBroadcast();
              },
            ),
          ),
        ),
      ],
    );
  }
}
