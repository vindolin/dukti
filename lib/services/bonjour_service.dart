// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bonsoir/bonsoir.dart' as bonsoir;

import '/models/app_constants.dart';
import '/models/client_provider.dart';
import '/network_helper.dart' show getUnusedPort, lookupIP4;
import '/models/client_name.dart';

import '/logger.dart';

part 'bonjour_service.g.dart';

const duktiServiceType = '_dukti._tcp';

@riverpod
FutureOr<int?> duktiServicePort(Ref ref) async {
  return await getUnusedPort<int>(
    (port) {
      logger.i('Using port $port');
      return port;
    },
  );
}

/// Start the bonsoir broadcast on a free port and returns the socket server
@riverpod
startBroadcast(Ref ref) async {
  final duktiServicePort = await ref.watch(duktiServicePortProvider.future);
  final service = bonsoir.BonsoirService(
    name: clientName,
    type: duktiServiceType,
    port: duktiServicePort!,
    attributes: {
      'platform': Platform.operatingSystem,
    },
  );

  bonsoir.BonsoirBroadcast broadcast = bonsoir.BonsoirBroadcast(service: service);
  await broadcast.ready;
  await broadcast.start();
}

/// Stream provider that listens to bonsoir events
@riverpod
Stream<List<bonsoir.BonsoirDiscoveryEvent>> events(Ref ref) async* {
  final discovery = bonsoir.BonsoirDiscovery(type: duktiServiceType);

  final clients = ref.read(duktiClientsProvider.notifier);
  await discovery.ready;
  discovery.start();

  var allEvents = <bonsoir.BonsoirDiscoveryEvent>[];
  if (discovery.eventStream != null) {
    await for (final event in discovery.eventStream!) {
      switch (event.type) {
        // found a service, lets resolve it
        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceFound:
          logger.i('Service found : ${event.service?.name}');
          event.service?.resolve(discovery.serviceResolver);
          break;

        // resolved a service, add it to the clients provider
        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceResolved:
          logger.i('Service resolved : ${event.service?.name}');

          final json = event.service?.toJson();
          final String? name = event.service?.name;
          final String? host = json?['service.host'];

          // only add it if it's not the current client
          if (name != null && host != null && name != clientName) {
            final platformString = json?['service.attributes']['platform'];
            final ClientPlatform platform = ClientPlatform.values.firstWhere(
              (e) => e.name == platformString,
              orElse: () => ClientPlatform.flutter,
            );

            DuktiClient client = DuktiClient(
              name: name,
              host: host,
              ip: await lookupIP4(host),
              port: json?['service.port'],
              platform: platform,
            );
            clients.set(name, client);
          }

          // we don't use those directly, use the clients map instead
          allEvents = [...allEvents, event];
          yield allEvents;
          break;

        // lost a service
        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceLost:
          logger.i('Service lost : ${event.service?.name}');

          // remove the client from the clients provider
          final String? name = event.service?.name;
          if (name != null) {
            clients.remove(name);
          }
          break;

        default:
          break;
      }
    }
  } else {
    throw 'no clients yet';
  }
}
