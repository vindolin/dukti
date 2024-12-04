import 'package:dukti/services/clipboard_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '/screens/home_screen.dart';
import '/services/bonjour_service.dart' as bonsoir;
import '/services/server_port_service.dart';
import '/models/client_name.dart';
import '/models/client_provider.dart';
import '/services/webserver_service.dart';
import 'utils/platform_helper.dart';

import 'utils/logger.dart';

/*
  Hot reload sadly does not work with the bonsoir plugin
  When hot reload is triggered, the old bonsoir broadcast is not stopped
  and the old device is still being broadcasted.
  see: https://stackoverflow.com/questions/69952232/handling-dispose-method-when-using-hot-restart
*/

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

class DuktiApp extends HookConsumerWidget {
  const DuktiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.t('Building DuktiApp');

    // If the app is resumed, the client list is probably outdated, invalidate it and start a new discovery.
    final appLifecycleState = useAppLifecycleState();
    useEffect(() {
      if (!platformIsDesktop) {
        if (appLifecycleState == AppLifecycleState.resumed) {
          // without the addPostFrameCallback, the error "Cannot listen to inherited widgets inside HookState.initState. Use HookState.build instead"
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.invalidate(duktiClientsProvider); // clear the client list
            ref.invalidate(bonsoir.eventsProvider); // restart the bonsoir discovery
          });
        }
      }
      return null;
    }, [appLifecycleState]);

    // final useDarkTheme = ref.watch(togglerTrueProvider('darkTheme')); // always use the system theme

    return _EagerInitialization(
        child: MaterialApp(
      title: 'Dukti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
      ),
      // themeMode: useDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const DuktiHome(title: 'Dukti!'),
    ));
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(clipboardServiceProvider);
    ref.watch(startWebServerProvider(serverPort!));
    ref.watch(bonsoir.eventsProvider);
    return child;
  }
}
