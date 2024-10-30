// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

import 'screens/client_screen.dart';
import 'services/bonjour_service.dart' as bonsoir_service;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bonsoir_service.startBroadcast();

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
  @override
  void initState() {
    super.initState();
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
        title: const Text('Dukti'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients.entries.elementAt(index);
              final name = client.key;
              final [host, ip] = client.value;
              return ListTile(
                title: Text(client.key),
                subtitle: Text('$host - $ip'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientPage(name: name, address: host, ip: ip),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
