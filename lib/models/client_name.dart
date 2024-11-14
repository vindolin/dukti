import 'dart:io';

import 'package:nanoid/nanoid.dart' as nanoid;
import '/platform_helper.dart';
import '/services/server_port_service.dart';

String clientName = '';

/// Initialize the client name e.g. Dukti:windows:12345678
Future<String> initClientName() async {
  String deviceName = await getDeviceName();
  clientName =
      'Dukti:${Platform.operatingSystem}:$deviceName:${nanoid.customAlphabet('1234567890abcdef', 8)}::${serverPort!}';
  return clientName;
}
