// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/bonjour_service.dart' as bonsoir_service;
import 'services/server_port_service.dart';
// import 'services/socket_service.dart' as socket_service;
import 'models/client_name.dart';
import 'services/webserver_service.dart';

import '/logger.dart';

/*
  Hot reload sadly does not work with the bonsoir plugin
  When hot reload is triggered, the old bonsoir broadcast is not stopped
  and the old device is still being broadcasted.
  see: https://stackoverflow.com/questions/69952232/handling-dispose-method-when-using-hot-restart
*/

void main() async {
  await getPort();
  logger.e('Using port $serverPort');
  await startServer(serverPort!);
  await initClientName();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: DuktiApp(),
    ),
  );
}

class DuktiApp extends ConsumerWidget {
  const DuktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building DuktiApp');

    ref.watch(bonsoir_service.eventsProvider); // start listening to events
    ref.watch(bonsoir_service.startBroadcastProvider); // broadcasting our dukti service
    // final socketEventStream = ref.watch(socket_service.socketEventsProvider);
    // logger.e(socketEventStream.value?.data);

    // startServer(ref);

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
