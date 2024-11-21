import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/client_name.dart';
import '/services/bonjour_service.dart';
import '/services/clipboard_service.dart';
import '/services/server_port_service.dart';
import '/services/webserver_service.dart';
import '/widgets/client_list_widget.dart';

class DuktiHome extends ConsumerStatefulWidget {
  final String title;
  const DuktiHome({super.key, required this.title});

  @override
  ConsumerState<DuktiHome> createState() => _DuktiHomeState();
}

class _DuktiHomeState extends ConsumerState<DuktiHome> {
  FToast? fToast;
  bool isBroadcasting = true;

  //TODO: use ScaffoldMessenger instead of FToast
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
    final clipboardStream = ref.watch(clipboardServiceProvider);
    final receiveProgress = ref.watch(receiveProgressProvider);

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
        title: Text('$clientUniqueName:$serverPort'),
        actions: [
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
      body: const Center(
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
        child: LinearProgressIndicator(value: receiveProgress),
      ),
    );
  }
}
