import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientScreen extends ConsumerWidget {
  final String name;
  final String address;
  final String ip;

  const ClientScreen({
    super.key,
    required this.name,
    required this.address,
    required this.ip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Client: $name'),
            Text('Address: $address'),
            Text('IP: $ip'),
          ],
        ),
      ),
    );
  }
}
