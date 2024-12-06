import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/platform_helper.dart';

part 'client_provider.g.dart';

class DuktiClient {
  final String name;
  final String id;
  final String? host;
  final String? ip;
  final int? port;
  final ClientPlatform? platform;
  final DateTime? lastSeen;

  DuktiClient({
    required this.name,
    required this.id,
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

  void set(DuktiClient client) {
    state = Map.from(state)..[client.id] = client;
  }

  // void remove(String id) {
  //   state = Map.from(state)..remove(id);
  // }

  void remove(String name) {
    state = Map.from(state)..remove(name);
  }

  void clear() {
    state = {};
  }
}
