import 'package:dukti/models/generic_providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/styles/decorations.dart';
import '/models/client_name.dart';
import '/services/bonjour_service.dart';
import '/services/clipboard_service.dart';
import '/services/webserver_service.dart';
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
    final useDarkTheme = ref.watch(togglerProvider('darkTheme'));

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            children: [
              TextSpan(
                text: clientName,
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
          Switch(
            value: useDarkTheme,
            onChanged: (value) {
              ref.read(togglerProvider('darkTheme').notifier).toggle();
            },
          ),
          // button that restarts the discovery
          IconButton(
            onPressed: () {
              // ref.read(duktiClientsProvider.notifier).clear();
              ref.invalidate(eventsProvider);
            },
            icon: const Icon(shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ], Icons.refresh),
          ),
          Switch(
            value: isBroadcasting,
            onChanged: (value) {
              setState(() {
                isBroadcasting = value;
                isBroadcasting ? startBroadcast() : stopBroadcast();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: fancyBackground,
        child: ClientList(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     stopBroadcast();
      //   },
      //   tooltip: 'Stop broadcasting',
      //   child: const Icon(Icons.close),
      // ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 50,
        child: ReceiveProgressWidget(),
      ),
    );
  }
}

class ReceiveProgressWidget extends ConsumerWidget {
  const ReceiveProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO implement upload list
    double progress = 0.0;
    final receiveProgress = ref.watch(uploadProgressProvider);
    if (receiveProgress.isNotEmpty) {
      progress = receiveProgress.values.first.progress;

      // if receiveProgress is 100%, start a timer and clear the progress after 1 second
      if (progress == 1.0) {
        Future.delayed(const Duration(seconds: 1), () {
          progress = 0.0;
        });
      }
    }

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[300],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
