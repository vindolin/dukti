import 'package:socket_io/socket_io.dart';

import '/logger.dart';

startSocketService(int port) {
  // Dart server
  var io = Server();
  var nsp = io.of('/some');
  nsp.on('connection', (client) {
    logger.i('connection /some');
    client.on('msg', (data) {
      logger.i('data from /some => $data');
      client.emit('fromServer', "ok 2");
    });
  });
  io.on('connection', (client) {
    logger.i('connection default namespace');
    client.on('msg', (data) {
      logger.i('data from default => $data');
      client.emit('fromServer', "ok");
    });
  });
  io.listen(port);
}
