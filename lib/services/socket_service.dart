import 'package:socket_io/socket_io.dart';

import '/logger.dart';

startSocketServer(int port) {
  // Dart server
  var io = Server();
  io.of('/clipboard').on('connection', (client) {
    logger.i('connection /clipboard');
    client.on('msg', (data) {
      logger.i('data from /some => $data');
      client.emit('fromServer', "ok 2");
    });
  });
  io.on('connection', (client) {
    // why does this only receive the first connection?
    logger.i('connection default namespace');
    client.on('msg', (data) {
      logger.i('data from default => $data');
      client.emit('fromServer', "ok");
    });
  });
  io.listen(port);
}
