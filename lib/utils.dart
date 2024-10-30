import 'dart:io' show InternetAddress, InternetAddressType, Platform;
import 'package:device_info_plus/device_info_plus.dart';

//TODO: utils is temporary, move contents to a separate files

Future getDeviceName() async {
  // get the device name
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String name;

  if (Platform.isAndroid) {
    name = (await deviceInfo.androidInfo).model;
  } else if (Platform.isIOS) {
    name = (await deviceInfo.iosInfo).localizedModel;
  } else if (Platform.isMacOS) {
    name = (await deviceInfo.macOsInfo).computerName;
  } else if (Platform.isWindows) {
    name = (await deviceInfo.windowsInfo).computerName;
  } else if (Platform.isLinux) {
    name = (await deviceInfo.linuxInfo).name;
  } else {
    name = 'Flutter';
  }

  return name;
}

lookupIP4(String host) async {
  String ip = '';
  await InternetAddress.lookup(host, type: InternetAddressType.IPv4).then((value) {
    ip = value.first.address;
  });
  return ip;
}
