import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generic_providers.g.dart';

@Riverpod(keepAlive: true)
class Toggler extends _$Toggler {
  @override
  bool build(String key) => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}
