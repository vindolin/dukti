import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '/services/bonjour_service.dart' as bonsoir_service;
import '/widgets/client_list_widget.dart';
// import '/logger.dart';

class DuktiHome extends ConsumerWidget {
  const DuktiHome({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(bonsoir_service.clientName),
      ),
      body: const Center(
        child: ClientList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
