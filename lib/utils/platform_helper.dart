import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';

bool platformIsDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

enum ClientPlatform { android, ios, macos, windows, linux, flutter }

Future getDeviceName() async {
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
