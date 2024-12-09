import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/client_provider.dart';
import '/styles/decorations.dart';
import '/services/bonjour_service.dart';
import '/services/clipboard_service.dart';
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
    final clipboardStream = ref.watch(clipboardServiceProvider);
    // final useDarkTheme = ref.watch(togglerTrueProvider('darkTheme'));

    // show snackbar on socket event
    if (clipboardStream.hasValue) {
      final clipboardData = clipboardStream.value;
      if (clipboardData != null) {
        // logger.e('Clipboard data: $clipboardData');
        Clipboard.setData(ClipboardData(text: clipboardData));
        _showToast(clipboardStream.value.toString());
      }
    }

    return Scaffold(
      appBar: DuktiAppBar(),
      body: Container(
        decoration: fancyBackground(Theme.of(context).brightness == Brightness.dark),
        child: ClientList(),
      ),
      floatingActionButton: FloatingActionButton(
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
