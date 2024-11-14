// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonjour_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$startBroadcastHash() => r'f253d2bebe312fd81b6bbad099616751337d326d';

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
String _$stopBroadcastHash() => r'b28b83f8778c309f14b91d5f28f60b8e74e32fbe';

/// See also [stopBroadcast].
@ProviderFor(stopBroadcast)
final stopBroadcastProvider = AutoDisposeProvider<void>.internal(
  stopBroadcast,
  name: r'stopBroadcastProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stopBroadcastHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StopBroadcastRef = AutoDisposeProviderRef<void>;
String _$eventsHash() => r'1029274ac2a81d324e1204050d515a66dbc0b758';

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
