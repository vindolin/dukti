import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/client_provider.dart';
import '/services/bonjour_service.dart';
import '/services/clipboard_service.dart';
import '/styles/decorations.dart';
import '/widgets/app_bar_widget.dart';
import 'client_list/widgets/client_list_widget.dart';

import '../utils/logger.dart';

class DuktiHome extends ConsumerStatefulWidget {
  final String title;
  const DuktiHome({super.key, required this.title});

  @override
  ConsumerState<DuktiHome> createState() => _DuktiHomeState();
}

class _DuktiHomeState extends ConsumerState<DuktiHome> {
  FToast? fToast;
  bool isBroadcasting = true;

  //TODO use ScaffoldMessenger instead of FToast
  @override
  initState() {
    super.initState();

    // initialize the toast
    fToast = FToast();
    fToast?.init(context);
  }

  _showToast(String message) {
    final toast = Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(5.0, 5.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );

    // if we don't use a future here, the toast will throw an error
    Future(
      () => fToast?.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.t('Building DuktiHome');
    final clipboard = ref.watch(clipboardServiceProvider);
    final clients = ref.watch(duktiClientsProvider);
    // final useDarkTheme = ref.watch(togglerTrueProvider('darkTheme'));

    if (clipboard != null) {
      Clipboard.setData(ClipboardData(text: clipboard));
      _showToast(clipboard.toString());
      Future.delayed(const Duration(seconds: 2), () {
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
