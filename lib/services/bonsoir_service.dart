// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:nanoid/nanoid.dart' as nanoid;
import 'package:bonsoir/bonsoir.dart';
import 'package:device_info_plus/device_info_plus.dart';

BonsoirService? service;

BonsoirService initBonsoirService(String deviceName) {
  return BonsoirService(
    name:
        'Dukti_${Platform.operatingSystem}:$deviceName:${nanoid.customAlphabet('1234567890abcdef', 10)}', // Put your service name here.
    type: '_dukti._tcp',
    port: 4645,
  );
}

Future<BonsoirBroadcast> startBonsoirBroadcast(String deviceName) async {
  BonsoirBroadcast broadcast = BonsoirBroadcast(service: initBonsoirService(deviceName));

  await broadcast.ready;
  await broadcast.start();

  return broadcast;
}

void startBonsoir() async {
  String type = '_dukti._tcp';
  BonsoirDiscovery discovery = BonsoirDiscovery(type: type);

  await discovery.ready;

  // If you want to listen to the discovery :
  discovery.eventStream!.listen((event) {
    // `eventStream` is not null as the discovery instance is "ready" !
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      print('Service found : ${event.service?.toJson()}');
      event.service!
          .resolve(discovery.serviceResolver); // Should be called when the user wants to connect to this service.
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      print('Service resolved : ${event.service?.toJson()}');
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      print('Service lost : ${event.service?.toJson()}');
    }
  });

// Start the discovery **after** listening to discovery events :
  await discovery.start();
}

void discover() async {
  String type = '_dukti._tcp';
  BonsoirDiscovery discovery = BonsoirDiscovery(type: type);

  await discovery.ready;

  // If you want to listen to the discovery :
  discovery.eventStream!.listen(
    (event) {
      // `eventStream` is not null as the discovery instance is "ready" !
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        print('Service found : ${event.service?.toJson()}');
        event.service!
            .resolve(discovery.serviceResolver); // Should be called when the user wants to connect to this service.
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        print('Service resolved : ${event.service?.toJson()}');
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        print('Service lost : ${event.service?.toJson()}');
      }
    },
  );

// Start the discovery **after** listening to discovery events :
  await discovery.start();

// Then if you want to stop the discovery :
  // await discovery.stop();
}
