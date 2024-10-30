// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonjour_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'7831ecb807f815a2f1c5108cb78f335f7c83708e';

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
String _$duktiClientsHash() => r'0247929af964b90e47b19bc04dc408a955f7f878';

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
