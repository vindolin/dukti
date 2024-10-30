// ignore_for_file: avoid_print
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'screens/client_screen.dart';
import 'services/bonjour_service.dart' as bonsoir_service;
import 'widgets/platform_icon_widget.dart';

/*
  Hot reload sadly does not work with the bonsoir plugin
  When hot reload is triggered, the old bonsoir broadcast is not stopped
  and the old device is still being broadcasted.
  see: https://stackoverflow.com/questions/69952232/handling-dispose-method-when-using-hot-restart
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bonsoir_service.setClientName();

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
  late final BonsoirBroadcast broadcast;

  @override
  initState() {
    super.initState();
    startBroadcast();
  }

  void startBroadcast() async {
    broadcast = await bonsoir_service.startBroadcast();
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

class DuktiHome extends ConsumerWidget {
  const DuktiHome({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients =
        ref.watch(bonsoir_service.duktiClientsProvider); // clients are dependent on the events provider further up

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(bonsoir_service.clientName),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final entry = clients.entries.elementAt(index);
            final name = entry.key;
            final client = entry.value;

            return ListTile(
              leading: PlatformIcon(platform: client.platform),
              title: Text(entry.key),
              // subtitle: Text('$ip ($host)'),
              subtitle: RichText(
                  text: TextSpan(
                children: [
                  TextSpan(text: client.ip, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  TextSpan(text: ' ($client.host)', style: const TextStyle(color: Colors.grey)),
                ],
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientScreen(name: name, address: client.host, ip: client.ip),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
