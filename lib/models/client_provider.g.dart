// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$duktiClientsHash() => r'c5b1e8b336734245a64c8ebb90e758dc3e7bf20f';

///  Provider that holds the clients discovered by bonsoir
///
/// Copied from [DuktiClients].
@ProviderFor(DuktiClients)
final duktiClientsProvider =
    NotifierProvider<DuktiClients, Map<String, DuktiClient>>.internal(
  DuktiClients.new,
  name: r'duktiClientsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$duktiClientsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DuktiClients = Notifier<Map<String, DuktiClient>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
