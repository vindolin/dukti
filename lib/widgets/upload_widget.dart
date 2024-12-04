import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';

import '/models/client_name.dart';
import '/models/client_provider.dart';
import '/utils/logger.dart';

part 'upload_widget.g.dart';

@riverpod
class UploadProgress extends _$UploadProgress {
  @override
  double build() {
    return 0.0;
  }

  void set(double value) {
    state = value;
  }
}

@riverpod
class UploadSpeed extends _$UploadSpeed {
  @override
  int build() {
    return 0;
  }

  void set(int value) {
    state = value;
  }
}

String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B/s';
  const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s', 'TB/s'];
  int i = (log(bytes) / log(1024)).floor();
  double size = bytes / pow(1024, i);
  return '${size.toStringAsFixed(2)} ${suffixes[i]}';
}

class UploadButton extends ConsumerWidget {
  final DuktiClient client;
  const UploadButton({super.key, required this.client});

  Future<void> _uploadFile(WidgetRef ref) async {
    final uploadProgressNotifier = ref.read(uploadProgressProvider.notifier);
    final uploadSpeedNotifier = ref.read(uploadSpeedProvider.notifier);

    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      final dio = Dio();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'clientId': clientId,
      });

      final address = 'http://${client.ip}:${client.port}/upload';

      final startTime = DateTime.now();

      try {
        await dio.post(
          address,
          data: formData,
          onSendProgress: (int sent, int total) {
            final currentTime = DateTime.now();
            final elapsedTime = currentTime.difference(startTime).inSeconds;
            if (elapsedTime > 0) {
              final speed = sent / elapsedTime; // bytes per second
              uploadSpeedNotifier.set(speed.toInt());
            }
            uploadProgressNotifier.set(sent / total);
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          uploadProgressNotifier.set(0.0);
          uploadSpeedNotifier.set(0);
        });

        logger.i('Upload complete');
      } catch (e) {
        logger.i('Upload failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadProgress = ref.watch(uploadProgressProvider);
    final uploadSpeed = ref.watch(uploadSpeedProvider);

    return uploadProgress == 0.0
        ? FilledButton(
            onPressed: () => _uploadFile(ref),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.upload),
                SizedBox(width: 8),
                const Text('Send a file'),
              ],
            ),
          )
        : SizedBox(
            width: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: uploadProgress,
                  minHeight: 32,
                  borderRadius: BorderRadius.circular(16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(uploadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Speed: ${formatBytes(uploadSpeed)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
