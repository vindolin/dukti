import 'package:nanoid/nanoid.dart' as nanoid;
import '/utils/platform_helper.dart';

String clientUniqueName = '';
String clientName = '';
String clientId = '';

/// Initialize the client name e.g. Dukti:windows:12345678
initClientName() async {
  clientName = await getDeviceName();
  clientId = nanoid.customAlphabet('1234567890abcdef', 8);
  clientUniqueName = '${clientName}_$clientId';
}
