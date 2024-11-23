import '../utils/network_helper.dart' show getUnusedPort;

int? serverPort;

initPort() async {
  serverPort = await getUnusedPort<int>(
    (port) {
      return port;
    },
  );
}
