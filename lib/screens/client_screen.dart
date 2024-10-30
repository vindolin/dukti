import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:socket_io/socket_io.dart';

class ClientScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Clipboard.getData('text/plain').then((value) {
            // open a socket to $ip and transfer the value
          });
        },
        tooltip: 'paste',
        child: const Icon(Icons.paste),
      ),
    );
  }
}
