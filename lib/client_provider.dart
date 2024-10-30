import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '/services/bonjour_service.dart';

part 'client_provider.g.dart';

class Client {
  final String name;
  final String address;
  final String ip;
  final ClientPlatform platform;

  Client({
    required this.name,
    required this.address,
    required this.ip,
    required this.platform,
  });
}

@Riverpod(keepAlive: true)
class Clients extends _$Clients {
  @override
  IList<Client> build() {
    return IList<Client>();
  }

  void add(Client client) {
    state = state.add(client);
  }
}
