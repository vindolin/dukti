import 'dart:io' show InternetAddress, InternetAddressType, Platform;
import 'package:device_info_plus/device_info_plus.dart';

//TODO: utils is temporary, move contents to a separate files

Future getDeviceName() async {
  // get the device name
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  final name = switch (Platform.operatingSystem) {
    'android' => (await deviceInfo.androidInfo).model,
    'ios' => (await deviceInfo.iosInfo).localizedModel,
    'macos' => (await deviceInfo.macOsInfo).computerName,
    'windows' => (await deviceInfo.windowsInfo).computerName,
    'linux' => (await deviceInfo.linuxInfo).name,
    _ => 'Flutter',
  };
  return name;
}

lookupIP4(String host) async {
  String ip = '';
  await InternetAddress.lookup(host, type: InternetAddressType.IPv4).then((value) {
    ip = value
        .firstWhere(
          (address) => !address.address.contains(
            '192.168.56', // filter out the virtualbox ip
          ),
        )
        .address;
  });
  return ip;
}
