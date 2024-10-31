import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_constants.dart';

part 'client_model.g.dart';

class Client {
  final String name;
  final String host;
  final String ip;
  final int port;
  final ClientPlatform platform;

  Client({
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
  Map<String, Client> build() {
    return {};
  }

  void set(String name, Client client) {
    state = Map.from(state)
      ..[name] = Client(
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
