import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/models/client_provider.dart';

import '/logger.dart';

part 'clipboard_service.g.dart';

@riverpod
class ClipboardService extends _$ClipboardService {
  late final StreamController<String> _controller;

  @override
  Stream<String> build() {
    _controller = StreamController<String>();

    ref.onDispose(() {
      _controller.close();
    });

    return _controller.stream;
  }

  void set(String text) {
    _controller.add(text);
  }
}

sendClipboard(DuktiClient client) async {
  final clipboardData = await Clipboard.getData('text/plain');
  // logger.e('Clipboard data: ${clipboardData?.text}');
  if (clipboardData != null && clipboardData.text != null) {
    final dio = Dio();
    try {
      final response = await dio.post(
        'http://${client.host}:${client.port}/clipboard',
        data: {'text': clipboardData.text},
      );
      logger.i('Clipboard data sent: ${response.statusCode}');
    } catch (e) {
      logger.e('Error sending clipboard data: $e');
    }
  } else {
    logger.w('No clipboard data to send');
  }
}
