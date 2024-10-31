// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:bonsoir/bonsoir.dart' as bonsoir;
import 'package:socket_io/socket_io.dart';

import '/models/app_constants.dart';
import '/services/socket_service.dart';
import '/network_helper.dart' show getUnusedPort, lookupIP4;
import '../platform_helper.dart';
import '../models/client_provider.dart';

import '/logger.dart';
part 'bonjour_service.g.dart';

const duktiServiceType = '_dukti._tcp';
int? duktiServicePort;

String clientName = '';

/// Initialize the client name e.g. Dukti:windows:12345678
initClientName() async {
  String deviceName = await getDeviceName();
  clientName = 'Dukti:${Platform.operatingSystem}:$deviceName:${nanoid.customAlphabet('1234567890abcdef', 8)}';
  return clientName;
}

/// Start the bonsoir broadcast
FutureOr<Server> startBroadcast() async {
  duktiServicePort = await getUnusedPort<int>(
    (port) {
      logger.i('Using port $port');
      return port;
    },
  );

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

  return startSocketServer(duktiServicePort!);
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
        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceFound:
          logger.i('Service found : ${event.service?.name}');
          event.service?.resolve(discovery.serviceResolver);
          break;

        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceResolved:
          logger.i('Service resolved : ${event.service?.name}');

          final json = event.service?.toJson();
          final String? name = event.service?.name;
          final String? host = json?['service.host'];

          // if not self, add the client to the clients provider
          if (name != null && host != null && name != clientName) {
            final platformString = json?['service.attributes']['platform'];
            final ClientPlatform platform = ClientPlatform.values.firstWhere(
              (e) => e.name == platformString,
              orElse: () => ClientPlatform.flutter,
            );

            Client client = Client(
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
