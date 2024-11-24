// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$togglerHash() => r'e0cf43b39f4d0e3b98726ca0c1fd5a71ed62cc82';

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

abstract class _$Toggler extends BuildlessNotifier<bool> {
  late final String key;

  bool build(
    String key,
  );
}

/// See also [Toggler].
@ProviderFor(Toggler)
const togglerProvider = TogglerFamily();

/// See also [Toggler].
class TogglerFamily extends Family<bool> {
  /// See also [Toggler].
  const TogglerFamily();

  /// See also [Toggler].
  TogglerProvider call(
    String key,
  ) {
    return TogglerProvider(
      key,
    );
  }

  @override
  TogglerProvider getProviderOverride(
    covariant TogglerProvider provider,
  ) {
    return call(
      provider.key,
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
  String? get name => r'togglerProvider';
}

/// See also [Toggler].
class TogglerProvider extends NotifierProviderImpl<Toggler, bool> {
  /// See also [Toggler].
  TogglerProvider(
    String key,
  ) : this._internal(
          () => Toggler()..key = key,
          from: togglerProvider,
          name: r'togglerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$togglerHash,
          dependencies: TogglerFamily._dependencies,
          allTransitiveDependencies: TogglerFamily._allTransitiveDependencies,
          key: key,
        );

  TogglerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  bool runNotifierBuild(
    covariant Toggler notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(Toggler Function() create) {
    return ProviderOverride(
      origin: this,
      override: TogglerProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  NotifierProviderElement<Toggler, bool> createElement() {
    return _TogglerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TogglerProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TogglerRef on NotifierProviderRef<bool> {
  /// The parameter `key` of this provider.
  String get key;
}

class _TogglerProviderElement extends NotifierProviderElement<Toggler, bool>
    with TogglerRef {
  _TogglerProviderElement(super.provider);

  @override
  String get key => (origin as TogglerProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
