import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'client_provider.g.dart';

class Client {
  final String name;
  final String address;
  Client(this.name, this.address);
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
