import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/services/socket_service.dart' as socket_service;
import '/models/client_name.dart';
import '/widgets/client_list_widget.dart';
// import '/logger.dart';

class DuktiHome extends ConsumerStatefulWidget {
  final String title;
  const DuktiHome({super.key, required this.title});

  @override
  ConsumerState<DuktiHome> createState() => _DuktiHomeState();
}

class _DuktiHomeState extends ConsumerState<DuktiHome> {
  FToast? fToast;

  //TODO: use ScaffoldMessenger instead of FToast

  static Future<void> setData(ClipboardData data) async {
    await SystemChannels.platform.invokeMethod<void>(
      'Clipboard.setData',
      <String, dynamic>{
        'text': data.text,
      },
    );
  }

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
    final socketEventStream = ref.watch(socket_service.socketEventsProvider);

    // show snackbar on socket event
    if (socketEventStream.hasValue) {
      final clipboardData = socketEventStream.value!.data.toString();
      if (clipboardData.isNotEmpty) {
        setData(ClipboardData(text: clipboardData));
      }
      _showToast(socketEventStream.value!.data.toString());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(clientName),
      ),
      body: const Center(
        child: ClientList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
