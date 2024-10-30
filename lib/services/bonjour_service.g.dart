// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonjour_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'1bf6b0771eca0eff57143fcd254f75fd98498637';

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
String _$duktiClientsHash() => r'd9bb1b928a05ca8fe9f7ab79e495d2a7a1287063';

///  Provider that holds the clients discovered by bonsoir
///
/// Copied from [DuktiClients].
@ProviderFor(DuktiClients)
final duktiClientsProvider = AutoDisposeNotifierProvider<DuktiClients,
    Map<String, List<String>>>.internal(
  DuktiClients.new,
  name: r'duktiClientsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$duktiClientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DuktiClients = AutoDisposeNotifier<Map<String, List<String>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
