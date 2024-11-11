import '/network_helper.dart' show getUnusedPort;

int? serverPort;

getPort() async {
  serverPort = await getUnusedPort<int>(
    (port) {
      return port;
    },
  );
}
