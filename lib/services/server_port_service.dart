import '../utils/network_helper.dart' show getUnusedPort;

int? serverPort;

/// Get an unused port and store it in [serverPort]
initPort() async {
  serverPort = await getUnusedPort<int>(
    (port) {
      return port;
    },
  );
}
