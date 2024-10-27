// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'services/bonsoir_service.dart' as bonsoir_service;
import 'utils.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final deviceName = await utils.getDeviceName();

  final broadcast = await bonsoir_service.startBonsoirBroadcast(deviceName);

  runApp(const DuktiApp());
  await broadcast.stop();
}

class DuktiApp extends StatelessWidget {
  const DuktiApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DuktiHome(title: 'Flutter Demo Home Page'),
    );
  }
}

class DuktiHome extends StatefulWidget {
  const DuktiHome({super.key, required this.title});

  final String title;

  @override
  State<DuktiHome> createState() => _DuktiHomeState();
}

class _DuktiHomeState extends State<DuktiHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'x',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: bonsoir_service.discover,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
