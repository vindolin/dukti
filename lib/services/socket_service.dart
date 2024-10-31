import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io/socket_io.dart';

import '/logger.dart';
import 'bonjour_service.dart';

part 'socket_service.g.dart';

@riverpod
startSocketServer(Ref ref) async {
  final duktiServicePort = await ref.watch(duktiServicePortProvider.future);

  var server = Server();
  server.of('/clipboard').on('connection', (client) {
    logger.i('connection /clipboard');
    client.on('msg', (data) {
      logger.i('data from /some => $data');
      client.emit('fromServer', "ok 2");
    });
  });
  server.on('connection', (client) {
    // why does this only receive the first connection? /clipboard works fine
    logger.i('connection default namespace');
    client.on('msg', (data) {
      logger.i('data from default => $data');
      client.emit('fromServer', "ok");
    });
  });
  server.listen(duktiServicePort);

  return server;
}
