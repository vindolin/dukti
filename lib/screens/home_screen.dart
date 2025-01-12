import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/models/client_provider.dart';
import '/services/bonjour_service.dart';
import '/services/clipboard_service.dart';
import '/styles/decorations.dart';
import '/widgets/app_bar_widget.dart';
import 'client_list/widgets/client_list_widget.dart';

import '../utils/logger.dart';

class DuktiHome extends ConsumerWidget {
  final String title;
  const DuktiHome({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building DuktiHome');
    final clipboard = ref.watch(clipboardServiceProvider);
    final clients = ref.watch(duktiClientsProvider);
    // final useDarkTheme = ref.watch(togglerTrueProvider('darkTheme'));

    if (clipboard != null) {
      Future(() {
        if (context.mounted) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Clipboard received:\n${clipboard.substring(0, math.min(clipboard.length, 100))}',
                overflow: TextOverflow.ellipsis),
          ));
        }
      });
      Clipboard.setData(ClipboardData(text: clipboard));

      // Clear the clipboard
      Future(() {
        ref.read(clipboardServiceProvider.notifier).set(null);
      });
    }

    return Scaffold(
      appBar: DuktiAppBar(),
      body: Container(
        decoration: fancyBackground(Theme.of(context).brightness == Brightness.dark),
        child: clients.isEmpty
            ? const Center(
                child: Text('Looks like we are alone here...'),
              )
            : const ClientList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Restart client discovery',
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        onPressed: () {
          ref.read(duktiClientsProvider.notifier).clear();
          ref.invalidate(eventsProvider);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
