// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonjour_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duktiServicePortHash() => r'c364c51f7d3eae7447b4a69bde31c92fc8d2c2ea';

/// See also [duktiServicePort].
@ProviderFor(duktiServicePort)
final duktiServicePortProvider = AutoDisposeFutureProvider<int?>.internal(
  duktiServicePort,
  name: r'duktiServicePortProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$duktiServicePortHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DuktiServicePortRef = AutoDisposeFutureProviderRef<int?>;
String _$startBroadcastHash() => r'156acbbc5e5600c4ad2f052a1892df1e3b9c99a6';

/// Start the bonsoir broadcast on a free port
///
/// Copied from [startBroadcast].
@ProviderFor(startBroadcast)
final startBroadcastProvider = AutoDisposeProvider<void>.internal(
  startBroadcast,
  name: r'startBroadcastProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$startBroadcastHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StartBroadcastRef = AutoDisposeProviderRef<void>;
String _$eventsHash() => r'cf22b922a44cb8e3c5a7cb6448fbec925202423c';

/// Stream provider that listens to bonsoir events
///
/// Copied from [events].
@ProviderFor(events)
final eventsProvider =
    AutoDisposeStreamProvider<List<bonsoir.BonsoirDiscoveryEvent>>.internal(
  events,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsRef
    = AutoDisposeStreamProviderRef<List<bonsoir.BonsoirDiscoveryEvent>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
