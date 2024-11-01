import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/platform_helper.dart';

part 'client_model.g.dart';

class DuktiClient {
  final String name;
  final String host;
  final String ip;
  final int port;
  final ClientPlatform platform;

  DuktiClient({
    required this.name,
    required this.host,
    required this.ip,
    required this.port,
    required this.platform,
  });
}

///  Provider that holds the clients discovered by bonsoir
@riverpod
class DuktiClients extends _$DuktiClients {
  @override
  Map<String, DuktiClient> build() {
    return {};
  }

  void set(String name, DuktiClient client) {
    state = Map.from(state)
      ..[name] = DuktiClient(
        name: name,
        host: client.host,
        ip: client.ip,
        port: client.port,
        platform: client.platform,
      );
  }

  void remove(String name) {
    state = Map.from(state)..remove(name);
  }
}
