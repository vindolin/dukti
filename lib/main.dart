// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socket_io/socket_io.dart';

import 'screens/home_screen.dart';
import 'services/bonjour_service.dart' as bonsoir_service;

/*
  Hot reload sadly does not work with the bonsoir plugin
  When hot reload is triggered, the old bonsoir broadcast is not stopped
  and the old device is still being broadcasted.
  see: https://stackoverflow.com/questions/69952232/handling-dispose-method-when-using-hot-restart
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bonsoir_service.initClientName();

  runApp(
    const ProviderScope(
      child: DuktiApp(),
    ),
  );
}

class DuktiApp extends ConsumerStatefulWidget {
  const DuktiApp({super.key});

  @override
  ConsumerState<DuktiApp> createState() => _DuktiAppState();
}

class _DuktiAppState extends ConsumerState<DuktiApp> {
  late final Server server;

  @override
  initState() {
    super.initState();
    startBroadcast();
  }

  void startBroadcast() async {
    server = await bonsoir_service.startBroadcast();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bonsoir_service.eventsProvider); // start listening to events

    return MaterialApp(
      title: 'Dukti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DuktiHome(title: 'Dukti!'),
    );
  }
}
