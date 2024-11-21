import 'package:dukti/services/clipboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/screens/home_screen.dart';
import '/services/bonjour_service.dart' as bonsoir;
import '/services/server_port_service.dart';
import '/models/client_name.dart';
import '/services/webserver_service.dart';

import '/logger.dart';

/*
  Hot reload sadly does not work with the bonsoir plugin
  When hot reload is triggered, the old bonsoir broadcast is not stopped
  and the old device is still being broadcasted.
  see: https://stackoverflow.com/questions/69952232/handling-dispose-method-when-using-hot-restart
*/

class AppLifecycleManager extends StatefulWidget {
  final Widget child;

  const AppLifecycleManager({super.key, required this.child});

  @override
  AppLifecycleManagerState createState() => AppLifecycleManagerState();
}

class AppLifecycleManagerState extends State<AppLifecycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Perform cleanup here
    // For example, stop servers, close streams, etc.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // The app is exiting
      // Perform cleanup if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPort();
  logger.e('Using port $serverPort');
  await initClientName();
  bonsoir.startBroadcast();

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

    ref.watch(clipboardServiceProvider);
    ref.watch(startWebServerProvider(serverPort!));
    ref.watch(bonsoir.eventsProvider);

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
