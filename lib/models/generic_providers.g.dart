// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$togglerFalseHash() => r'4b4db5274330c9818980dcd3eeb02d15fd255948';

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

abstract class _$TogglerFalse extends BuildlessNotifier<bool> {
  late final String key;

  bool build(
    String key,
  );
}

/// See also [TogglerFalse].
@ProviderFor(TogglerFalse)
const togglerFalseProvider = TogglerFalseFamily();

/// See also [TogglerFalse].
class TogglerFalseFamily extends Family<bool> {
  /// See also [TogglerFalse].
  const TogglerFalseFamily();

  /// See also [TogglerFalse].
  TogglerFalseProvider call(
    String key,
  ) {
    return TogglerFalseProvider(
      key,
    );
  }

  @override
  TogglerFalseProvider getProviderOverride(
    covariant TogglerFalseProvider provider,
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
  String? get name => r'togglerFalseProvider';
}

/// See also [TogglerFalse].
class TogglerFalseProvider extends NotifierProviderImpl<TogglerFalse, bool> {
  /// See also [TogglerFalse].
  TogglerFalseProvider(
    String key,
  ) : this._internal(
          () => TogglerFalse()..key = key,
          from: togglerFalseProvider,
          name: r'togglerFalseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$togglerFalseHash,
          dependencies: TogglerFalseFamily._dependencies,
          allTransitiveDependencies:
              TogglerFalseFamily._allTransitiveDependencies,
          key: key,
        );

  TogglerFalseProvider._internal(
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
    covariant TogglerFalse notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(TogglerFalse Function() create) {
    return ProviderOverride(
      origin: this,
      override: TogglerFalseProvider._internal(
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
  NotifierProviderElement<TogglerFalse, bool> createElement() {
    return _TogglerFalseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TogglerFalseProvider && other.key == key;
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
mixin TogglerFalseRef on NotifierProviderRef<bool> {
  /// The parameter `key` of this provider.
  String get key;
}

class _TogglerFalseProviderElement
    extends NotifierProviderElement<TogglerFalse, bool> with TogglerFalseRef {
  _TogglerFalseProviderElement(super.provider);

  @override
  String get key => (origin as TogglerFalseProvider).key;
}

String _$togglerTrueHash() => r'9dc8cb29f2b00e5ca152be6ba72fe428bba2d868';

abstract class _$TogglerTrue extends BuildlessNotifier<bool> {
  late final String key;

  bool build(
    String key,
  );
}

/// See also [TogglerTrue].
@ProviderFor(TogglerTrue)
const togglerTrueProvider = TogglerTrueFamily();

/// See also [TogglerTrue].
class TogglerTrueFamily extends Family<bool> {
  /// See also [TogglerTrue].
  const TogglerTrueFamily();

  /// See also [TogglerTrue].
  TogglerTrueProvider call(
    String key,
  ) {
    return TogglerTrueProvider(
      key,
    );
  }

  @override
  TogglerTrueProvider getProviderOverride(
    covariant TogglerTrueProvider provider,
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
  String? get name => r'togglerTrueProvider';
}

/// See also [TogglerTrue].
class TogglerTrueProvider extends NotifierProviderImpl<TogglerTrue, bool> {
  /// See also [TogglerTrue].
  TogglerTrueProvider(
    String key,
  ) : this._internal(
          () => TogglerTrue()..key = key,
          from: togglerTrueProvider,
          name: r'togglerTrueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$togglerTrueHash,
          dependencies: TogglerTrueFamily._dependencies,
          allTransitiveDependencies:
              TogglerTrueFamily._allTransitiveDependencies,
          key: key,
        );

  TogglerTrueProvider._internal(
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
    covariant TogglerTrue notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(TogglerTrue Function() create) {
    return ProviderOverride(
      origin: this,
      override: TogglerTrueProvider._internal(
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
  NotifierProviderElement<TogglerTrue, bool> createElement() {
    return _TogglerTrueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TogglerTrueProvider && other.key == key;
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
mixin TogglerTrueRef on NotifierProviderRef<bool> {
  /// The parameter `key` of this provider.
  String get key;
}

class _TogglerTrueProviderElement
    extends NotifierProviderElement<TogglerTrue, bool> with TogglerTrueRef {
  _TogglerTrueProviderElement(super.provider);

  @override
  String get key => (origin as TogglerTrueProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
