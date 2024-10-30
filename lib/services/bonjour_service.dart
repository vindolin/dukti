// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:bonsoir/bonsoir.dart' as bonsoir;
import 'package:logger/logger.dart';

import '/client_provider.dart';
import '/utils.dart' as utils;

part 'bonjour_service.g.dart';

enum ClientPlatform { android, ios, macos, windows, linux, flutter }

var logger = Logger();

const duktiServiceType = '_dukti._tcp';
const duktiServicePort = 4645;

String clientName = '';

setClientName() async {
  String deviceName = await utils.getDeviceName();
  clientName = 'Dukti:${Platform.operatingSystem}:$deviceName:${nanoid.customAlphabet('1234567890abcdef', 8)}';
}

/// Start the bonsoir broadcast
startBroadcast() async {
  final service = bonsoir.BonsoirService(
    name: clientName,
    type: duktiServiceType,
    port: duktiServicePort,
    attributes: {
      'platform': Platform.operatingSystem,
    },
  );

  bonsoir.BonsoirBroadcast broadcast = bonsoir.BonsoirBroadcast(service: service);
  await broadcast.ready;
  await broadcast.start();

  return broadcast;
}

///  Provider that holds the clients discovered by bonsoir
@riverpod
class DuktiClients extends _$DuktiClients {
  @override
  Map<String, Client> build() {
    return {};
  }

  void set(String name, Client client) {
    state = Map.from(state)..[name] = Client(name: name, host: client.host, ip: client.ip, platform: client.platform);
  }

  void remove(String name) {
    state = Map.from(state)..remove(name);
  }
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
          // Add the client to the clients provider
          final String? host = json?['service.host'];

          if (name != null && host != null && name != clientName) {
            final platformString = json?['service.attributes']['platform'];
            final ClientPlatform platform = ClientPlatform.values.firstWhere(
              (e) => e.name == platformString,
              orElse: () => ClientPlatform.flutter,
            );

            Client client = Client(
              name: name,
              host: host,
              ip: await utils.lookupIP4(host),
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
