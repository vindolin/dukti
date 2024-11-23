import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/platform_helper.dart';

part 'client_model.g.dart';

class DuktiClient {
  final String name;
  final String? host;
  final String? ip;
  final int? port;
  final ClientPlatform? platform;
  final DateTime? lastSeen;

  DuktiClient({
    required this.name,
    this.host,
    this.ip,
    this.port,
    this.platform,
  }) : lastSeen = DateTime.now();
}

///  Provider that holds the clients discovered by bonsoir
@Riverpod(keepAlive: true)
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

  void clear() {
    state = {};
  }
}
