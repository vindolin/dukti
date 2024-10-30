// ignore_for_file: avoid_print
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

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
    ref.read(bonsoir_service.duktiClientsProvider);

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
    ref.watch(bonsoir_service.eventsProvider);
    final clients = ref.watch(bonsoir_service.duktiClientsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('meep'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients.entries.elementAt(index);
              return ListTile(
                title: Text(client.key),
                subtitle: Text('${client.value[0]} - ${client.value[1]}'),
                onTap: () {
                  print(client);
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // print(bonsoirProvider);
          // print(bonsoirServiceX.clients);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
