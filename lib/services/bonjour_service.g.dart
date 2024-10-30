// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonjour_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'f2c533592ec8a4a79c7b93cdf8981885e51ce9e0';

/// Stream provider that listens to bonsoir events
///
/// Copied from [events].
@ProviderFor(events)
final eventsProvider =
    StreamProvider<List<bonsoir.BonsoirDiscoveryEvent>>.internal(
  events,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EventsRef = StreamProviderRef<List<bonsoir.BonsoirDiscoveryEvent>>;
String _$duktiClientsHash() => r'3a3fa67f05bf391e94331c47b97a88c4b11a9abd';

///  Provider that holds the clients discovered by bonsoir
///
/// Copied from [DuktiClients].
@ProviderFor(DuktiClients)
final duktiClientsProvider =
    NotifierProvider<DuktiClients, Map<String, List<String>>>.internal(
  DuktiClients.new,
  name: r'duktiClientsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$duktiClientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DuktiClients = Notifier<Map<String, List<String>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
