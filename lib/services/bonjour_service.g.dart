// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonjour_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'835c0185993dfb9bd0d8dea18d2e51fbf84582af';

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
String _$isBroadcastingHash() => r'625ff3f3a6391511027c1a5e25d08d171b3b936c';

/// provider for the broadcast status
///
/// Copied from [IsBroadcasting].
@ProviderFor(IsBroadcasting)
final isBroadcastingProvider =
    AutoDisposeNotifierProvider<IsBroadcasting, bool>.internal(
  IsBroadcasting.new,
  name: r'isBroadcastingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isBroadcastingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsBroadcasting = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
