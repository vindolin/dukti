import 'package:dukti/services/bonjour_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<ClientPlatform, IconData> platformIcons = {
  ClientPlatform.android: Icons.android,
  ClientPlatform.ios: Icons.phone_iphone,
  ClientPlatform.macos: FontAwesomeIcons.apple,
  ClientPlatform.windows: FontAwesomeIcons.windows,
  ClientPlatform.linux: FontAwesomeIcons.linux,
  ClientPlatform.flutter: Icons.flutter_dash,
};

class PlatformIcon extends StatelessWidget {
  final ClientPlatform platform;
  const PlatformIcon({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Icon(platformIcons[platform]);
  }
}
