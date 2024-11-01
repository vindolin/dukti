import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io/socket_io.dart';

import '/logger.dart';
import 'bonjour_service.dart';

part 'socket_service.g.dart';

class SocketEvent {
  final String namespace;
  final String eventName;
  final dynamic data;

  SocketEvent({
    required this.namespace,
    required this.eventName,
    this.data,
  });
}

/// Controller for the socket events
final _socketEventController = StateProvider<StreamController<SocketEvent>>((ref) {
  return StreamController<SocketEvent>.broadcast();
});

/// Stream provider for the socket events
@riverpod
Stream<SocketEvent> socketEvents(Ref ref) async* {
  final duktiServicePort = await ref.watch(duktiServicePortProvider.future);

  var server = Server();

  // Handle events on the '/clipboard' namespace
  server.of('/clipboard').on('connection', (client) {
    logger.i('Connection on /clipboard');

    client.on('msg', (data) {
      logger.i('Data from /clipboard => $data');
      client.emit('fromServer', 'ok');

      // Yield the event
      final event = SocketEvent(
        namespace: '/clipboard',
        eventName: 'msg',
        data: data,
      );
      ref.read(_socketEventController).add(event);
    });
  });

  // Handle events on the default namespace
  server.on('connection', (client) {
    logger.i('Connection on default namespace');

    client.on('event', (data) {
      logger.i('Data from default namespace => $data');
      client.emit('fromServer', 'ok');

      // Yield the event
      final event = SocketEvent(
        namespace: '/',
        eventName: 'event',
        data: data,
      );
      ref.read(_socketEventController).add(event);
    });
  });

  // Start the server
  server.listen(duktiServicePort);

  // Stream controller to emit socket events
  final controller = StreamController<SocketEvent>();

  // Expose the controller to be used in callbacks
  ref.read(_socketEventController.notifier).state = controller;

  // Dispose resources when the provider is destroyed
  ref.onDispose(() {
    server.close();
    controller.close();
  });

  yield* controller.stream;
}
