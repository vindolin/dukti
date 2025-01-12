import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/services/dio_service.dart';
import '/models/client_provider.dart';

import '../utils/logger.dart';

part 'clipboard_service.g.dart';

@riverpod
class ClipboardService extends _$ClipboardService {
  @override
  String? build() {
    return null;
  }

  void set(String? text) {
    state = text;
  }
}

class EmptyClipboardException implements Exception {}

class ClipboardException implements Exception {}

/// Sends the clipboard data to the client
sendClipboard(DuktiClient client) async {
  final clipboardData = await Clipboard.getData('text/plain');
  // logger.e('Clipboard data: ${clipboardData?.text}');
  if (clipboardData != null && clipboardData.text != null) {
    try {
      // final response = await Dio().post(
      final response = await createDio('https://${client.ip}:${client.port}').post(
        '/clipboard',
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
