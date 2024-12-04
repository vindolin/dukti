import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brightness_provider.g.dart';

@Riverpod(keepAlive: true)
class BrightnessProvider extends _$BrightnessProvider {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}
