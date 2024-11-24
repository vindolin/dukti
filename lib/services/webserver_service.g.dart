// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webserver_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$startWebServerHash() => r'f11c9f4b27fdea36f4c148cf889cc5d52939f9fa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [startWebServer].
@ProviderFor(startWebServer)
const startWebServerProvider = StartWebServerFamily();

/// See also [startWebServer].
class StartWebServerFamily extends Family<AsyncValue<void>> {
  /// See also [startWebServer].
  const StartWebServerFamily();

  /// See also [startWebServer].
  StartWebServerProvider call(
    int port,
  ) {
    return StartWebServerProvider(
      port,
    );
  }

  @override
  StartWebServerProvider getProviderOverride(
    covariant StartWebServerProvider provider,
  ) {
    return call(
      provider.port,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'startWebServerProvider';
}

/// See also [startWebServer].
class StartWebServerProvider extends AutoDisposeFutureProvider<void> {
  /// See also [startWebServer].
  StartWebServerProvider(
    int port,
  ) : this._internal(
          (ref) => startWebServer(
            ref as StartWebServerRef,
            port,
          ),
          from: startWebServerProvider,
          name: r'startWebServerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$startWebServerHash,
          dependencies: StartWebServerFamily._dependencies,
          allTransitiveDependencies:
              StartWebServerFamily._allTransitiveDependencies,
          port: port,
        );

  StartWebServerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.port,
  }) : super.internal();

  final int port;

  @override
  Override overrideWith(
    FutureOr<void> Function(StartWebServerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StartWebServerProvider._internal(
        (ref) => create(ref as StartWebServerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        port: port,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _StartWebServerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StartWebServerProvider && other.port == port;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, port.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StartWebServerRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `port` of this provider.
  int get port;
}

class _StartWebServerProviderElement
    extends AutoDisposeFutureProviderElement<void> with StartWebServerRef {
  _StartWebServerProviderElement(super.provider);

  @override
  int get port => (origin as StartWebServerProvider).port;
}

String _$uploadProgressHash() => r'c48342e9e827dff97f03c2e20123e669588b0e6e';

/// See also [UploadProgress].
@ProviderFor(UploadProgress)
final uploadProgressProvider =
    NotifierProvider<UploadProgress, Map<String, Upload>>.internal(
  UploadProgress.new,
  name: r'uploadProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uploadProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UploadProgress = Notifier<Map<String, Upload>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
