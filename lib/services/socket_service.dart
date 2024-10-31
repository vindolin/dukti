import 'package:socket_io/socket_io.dart';

import '/logger.dart';

// part 'socket_service.g.dart';

// @riverpod
// class SocketServer {
//   build() {
//     return startSocketServer(3000);
//   }
// }

Server startSocketServer(int port) {
  // Dart server
  var server = Server();
  server.of('/clipboard').on('connection', (client) {
    logger.i('connection /clipboard');
    client.on('msg', (data) {
      logger.i('data from /some => $data');
      client.emit('fromServer', "ok 2");
    });
  });
  server.on('connection', (client) {
    // why does this only receive the first connection?
    logger.i('connection default namespace');
    client.on('msg', (data) {
      logger.i('data from default => $data');
      client.emit('fromServer', "ok");
    });
  });
  server.listen(port);

  return server;
}
