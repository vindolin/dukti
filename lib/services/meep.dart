// ignore_for_file: avoid_print

import 'package:bonsoir/bonsoir.dart';

String type = '_dukti._tcp';

meep() async {
// Once defined, we can start the discovery :
  BonsoirDiscovery discovery = BonsoirDiscovery(type: type);
  await discovery.ready;

// If you want to listen to the discovery :
  discovery.eventStream!.listen((event) {
    // `eventStream` is not null as the discovery instance is "ready" !
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      print('Service found : ${event.service!.toJson()}');
      event.service!
          .resolve(discovery.serviceResolver); // Should be called when the user wants to connect to this service.
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      print('Service resolved : ${event.service!.toJson()}');
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      print('Service lost : ${event.service?.toJson()}');
    }
  });

// Start the discovery **after** listening to discovery events :
  await discovery.start();
}
