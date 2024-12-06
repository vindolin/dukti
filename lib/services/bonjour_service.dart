// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bonsoir/bonsoir.dart' as bonsoir;

import '/utils/platform_helper.dart';
import '/models/client_provider.dart';
import '/utils/network_helper.dart' show lookupIP4, knockPort;
import '/models/client_name.dart';
import '/services/server_port_service.dart' as server_port_service;

import '/utils/logger.dart';

part 'bonjour_service.g.dart';

const duktiServiceType = '_dukti._tcp';

final _service = bonsoir.BonsoirService(
  name: clientUniqueName,
  type: duktiServiceType,
  port: server_port_service.serverPort!,
  attributes: {
    'platform': Platform.operatingSystem,
  },
);

bonsoir.BonsoirBroadcast? _broadcast;

/// Start the bonsoir broadcast on a free port
void startBroadcast() async {
  _broadcast = bonsoir.BonsoirBroadcast(service: _service);
  logger.e('Starting broadcast');
  await _broadcast?.ready;
  await _broadcast?.start();
}

void stopBroadcast() async {
  await _broadcast?.stop();
}

Timer? _staleClientTimer;

/// Remove clients that are no longer reacting to pings
void removeStaleClients(Ref ref) {
  _staleClientTimer ??= Timer.periodic(
    Duration(seconds: 30),
    (timer) async {
      final clients = ref.read(duktiClientsProvider);
      // logger.i('Checking for stale clients');

      for (var client in clients.values) {
        if (client.ip != null && client.port != null) {
          if (!await knockPort(client.ip!, client.port!)) {
            // clients.remove(client.name);
            ref.read(duktiClientsProvider.notifier).remove(client.id);
            logger.i('Client ${client.name}@${client.host}:${client.port} is offline and has been removed.');
          }
        }
      }
    },
  );
}

/// parse the client.name like "name_68b80958" into clientName, clientId, uniqueName
List<String> parseUniqueName(String? uniqueName) {
  if (uniqueName == null) {
    throw Exception('Invalid service name: $uniqueName');
  }
  final parts = uniqueName.split('_');
  if (parts.length != 2) {
    throw Exception('Invalid service name: $uniqueName');
  }
  return parts..add(uniqueName);
}

/// Stream provider that listens to bonsoir events
@riverpod
Stream<List<bonsoir.BonsoirDiscoveryEvent>> events(Ref ref) async* {
  logger.i('Starting bonsoir discovery');
  final discovery = bonsoir.BonsoirDiscovery(type: duktiServiceType, printLogs: false);
  final clients = ref.read(duktiClientsProvider.notifier);

  removeStaleClients(ref);
  await discovery.ready;
  discovery.start();

  var allEvents = <bonsoir.BonsoirDiscoveryEvent>[];

  await for (final event in discovery.eventStream!) {
    if (event.service == null) {
      logger.i('Service is null');
      continue;
    }

    final [name, id, uniqueName] = parseUniqueName(event.service?.name);
    switch (event.type) {
      // found a service, resolve it
      case bonsoir.BonsoirDiscoveryEventType.discoveryServiceFound:
        logger.i('Service found : ${event.service?.name}');

        // ignore self
        if (uniqueName != clientUniqueName) {
          DuktiClient client = DuktiClient(
            id: id,
            name: name,
          );
          clients.set(client);

          // resolve this client
          Future.delayed(Duration(milliseconds: 1000), () {
            // if we resolve too quickly, the client might not be ready
            event.service?.resolve(discovery.serviceResolver);
          });
        }
        break;

      // resolved a service, add it to the clients provider
      case bonsoir.BonsoirDiscoveryEventType.discoveryServiceResolved:
        logger.i('Service resolved : ${event.service?.name}');

        final json = event.service?.toJson();
        final String? host = json?['service.host'];

        // ignore self
        if (host != null && uniqueName != clientUniqueName) {
          final platformString = json?['service.attributes']['platform'];
          final port = json?['service.port'];
          final ip = await lookupIP4(host);

          // check if the client is still alive
          if (!await knockPort(ip, port)) {
            logger.t('Resolved dead client: $name $ip:$port');
            // TODO remove the client from the clients provider
            clients.remove(id);
            break;
          }

          final ClientPlatform platform = ClientPlatform.values.firstWhere(
            (e) => e.name == platformString,
            orElse: () => ClientPlatform.flutter,
          );

          DuktiClient client = DuktiClient(
            id: id,
            name: name,
            host: host,
            ip: ip,
            port: port,
            platform: platform,
          );
          clients.set(client);
        } else {
          logger.e('Ignoring self');
        }

        // we don't use those directly, use the clients map directly
        allEvents = [...allEvents, event];
        yield allEvents;
        break;

      // lost a service
      case bonsoir.BonsoirDiscoveryEventType.discoveryServiceLost:
        logger.i('Service lost : ${event.service?.name}');
        // remove the client from the clients provider
        clients.remove(id);
        break;

      default:
        break;
    }
  }
}
