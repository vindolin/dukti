// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bonsoir/bonsoir.dart' as bonsoir;

import '/platform_helper.dart';
import '/models/client_provider.dart';
import '/network_helper.dart' show lookupIP4;
import '/models/client_name.dart';
import '/services/server_port_service.dart' as server_port_service;

import '/logger.dart';

part 'bonjour_service.g.dart';

const duktiServiceType = '_dukti._tcp';

final _service = bonsoir.BonsoirService(
  name: clientName,
  type: duktiServiceType,
  port: server_port_service.serverPort!,
  attributes: {
    'platform': Platform.operatingSystem,
  },
);

bonsoir.BonsoirBroadcast _broadcast = bonsoir.BonsoirBroadcast(service: _service);

/// Start the bonsoir broadcast on a free port
@riverpod
void startBroadcast(Ref ref) async {
  await _broadcast.ready;
  await _broadcast.start();
}

@riverpod
void stopBroadcast(Ref ref) async {
  await _broadcast.stop();
}

/// Stream provider that listens to bonsoir events
@riverpod
Stream<List<bonsoir.BonsoirDiscoveryEvent>> events(Ref ref) async* {
  final discovery = bonsoir.BonsoirDiscovery(type: duktiServiceType);

  final clients = ref.watch(duktiClientsProvider.notifier);
  await discovery.ready;
  discovery.start();

  var allEvents = <bonsoir.BonsoirDiscoveryEvent>[];
  if (discovery.eventStream != null) {
    await for (final event in discovery.eventStream!) {
      switch (event.type) {
        // found a service, lets resolve it
        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceFound:
          logger.i('Service found : ${event.service!.name}');
          await event.service!.resolve(discovery.serviceResolver);
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
