// ignore_for_file: avoid_print

import 'dart:io' show InternetAddress, InternetAddressType, Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:bonsoir/bonsoir.dart' as bonsoir;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/utils.dart' as utils;

part 'bonjour_service.g.dart';

const duktiServiceType = '_dukti._tcp';

startBroadcast() async {
  String deviceName = await utils.getDeviceName();

  final service = bonsoir.BonsoirService(
    name:
        'Dukti_${Platform.operatingSystem}:$deviceName:${nanoid.customAlphabet('1234567890abcdef', 10)}', // Put your service name here.
    type: duktiServiceType,
    port: 4645,
  );

  bonsoir.BonsoirBroadcast broadcast = bonsoir.BonsoirBroadcast(service: service);
  await broadcast.ready;
  await broadcast.start();
}

@riverpod
class DuktiClients extends _$DuktiClients {
  @override
  Map<String, List<String>> build() {
    return {};
  }

  void set(String name, String address, String ip) {
    state = Map.from(state)..[name] = [address, ip];
  }
}

lookupIP4(String host) async {
  String ip = '';
  await InternetAddress.lookup(host, type: InternetAddressType.IPv4).then((value) {
    ip = value.first.address;
  });
  return ip;
}

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
          print('Service found : ${event.service?.toJson()}');
          event.service?.resolve(discovery.serviceResolver);
          break;

        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceResolved:
          print('Service resolved : ${event.service?.toJson()}');
          final json = event.service?.toJson();

          final String? name = event.service?.name;
          final String? host = json?['service.host'];
          // Add the client to the list of clients
          if (name != null && host != null) {
            clients.set(name, host, await lookupIP4(host));
          }

          // we don't use those directly, use the clients map instead
          allEvents = [...allEvents, event];
          yield allEvents;
          break;

        case bonsoir.BonsoirDiscoveryEventType.discoveryServiceLost:
          print('Service lost : ${event.service?.toJson()}');
          break;

        default:
          break;
      }
    }
  } else {
    throw 'no clients yet';
  }
}
