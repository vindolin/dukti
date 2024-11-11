// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import '/logger.dart';
// import 'bonjour_service.dart';

// part 'socket_service.g.dart';

enum SocketDataType { clipboard, upload, none }

class SocketEvent {
  final String namespace;
  final String eventName;
  final SocketDataType type;
  final dynamic data;

  SocketEvent({
    required this.namespace,
    required this.eventName,
    required this.type,
    this.data,
  });
}
