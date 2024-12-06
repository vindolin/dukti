import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/models/client_provider.dart';

import '../utils/logger.dart';

part 'clipboard_service.g.dart';

@riverpod
class ClipboardService extends _$ClipboardService {
  final StreamController<String> _controller = StreamController<String>();

  @override
  Stream<String> build() {
    ref.onDispose(() {
      _controller.close();
    });

    return _controller.stream;
  }

  void set(String text) {
    _controller.add(text);
  }
}

class EmptyClipboardException implements Exception {}

class ClipboardException implements Exception {}

sendClipboard(DuktiClient client) async {
  final clipboardData = await Clipboard.getData('text/plain');
  // logger.e('Clipboard data: ${clipboardData?.text}');
  if (clipboardData != null && clipboardData.text != null) {
    try {
      final response = await Dio().post(
        'http://${client.host}:${client.port}/clipboard',
        data: {'text': clipboardData.text},
      );
      logger.i('Clipboard data sent: ${response.statusCode}');
    } catch (e) {
      throw ClipboardException();
    }
  } else {
    // logger.w('No clipboard data to send');
    throw EmptyClipboardException();
  }
}
