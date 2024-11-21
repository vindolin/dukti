import 'package:nanoid/nanoid.dart' as nanoid;
import '/platform_helper.dart';

String clientUniqueName = '';

/// Initialize the client name e.g. Dukti:windows:12345678
initClientName() async {
  final clientName = await getDeviceName();
  final clientId = nanoid.customAlphabet('1234567890abcdef', 8);
  clientUniqueName = '${clientName}_$clientId';
}
