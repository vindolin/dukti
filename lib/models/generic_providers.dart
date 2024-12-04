import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generic_providers.g.dart';

@Riverpod(keepAlive: true)
class TogglerFalse extends _$TogglerFalse {
  @override
  bool build(String key) => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class TogglerTrue extends _$TogglerTrue {
  @override
  bool build(String key) => true;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}
