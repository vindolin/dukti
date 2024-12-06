import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '/models/client_name.dart';
import '/models/client_provider.dart';
import '/utils/logger.dart';

// part 'upload_widget.g.dart';

// @riverpod
// class UploadProgress extends _$UploadProgress {
//   @override
//   double build() {
//     return 0.0;
//   }

//   void set(double value) {
//     state = value;
//   }
// }

// @riverpod
// class UploadProgressStream extends _$UploadProgressStream {
//   final StreamController<double> _controller = StreamController<double>();

//   @override
//   Stream<double> build() {
//     ref.onDispose(() {
//       _controller.close();
//     });

//     return _controller.stream;
//   }

//   void set(double value) {
//     _controller.add(value);
//   }
// }

// @riverpod
// class UploadSpeed extends _$UploadSpeed {
//   @override
//   int build() {
//     return 0;
//   }

//   void set(int value) {
//     state = value;
//   }
// }

// @riverpod
// class FileSelectorOpen extends _$FileSelectorOpen {
//   @override
//   bool build() {
//     return false;
//   }

//   void set(bool value) {
//     state = value;
//   }
// }

String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B/s';
  const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s', 'TB/s'];
  int i = (log(bytes) / log(1024)).floor();
  double size = bytes / pow(1024, i);
  return '${size.toStringAsFixed(2)} ${suffixes[i]}';
}

class UploadButton extends ConsumerStatefulWidget {
  final DuktiClient client;
  const UploadButton({super.key, required this.client});

  @override
  ConsumerState<UploadButton> createState() => _UploadButtonState();
}

FutureOr<String?> pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.single.path != null) {
    final filePath = result.files.single.path!;
    logger.i('Uploading file: $filePath');
    return filePath;
  }
  return null;
}

void uploadFile(
  String filePath,
  DuktiClient client,
  Function(double) updateProgress,
  Function(int) updateSpeed,
) async {
  // fileSelectorOpen.set(true);
  // setState(() => fileSelectorOpen2 = true);

  // final result = await FilePicker.platform.pickFiles();

  // // fileSelectorOpen.set(false);
  // setState(() => fileSelectorOpen2 = false);

  // final filePath = '/data/user/0/com.atomar.dukti/cache/file_picker/1733349332034/youtube.apk';

  logger.i('Uploading file: $filePath');

  final dio = Dio();

  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(filePath),
    'clientId': clientId,
  });

  final address = 'http://${client.ip}:${client.port}/upload';
  logger.i('Uploading to: $address');

  final startTime = DateTime.now();

  try {
    await dio.post(
      address,
      data: formData,
      onSendProgress: (int sent, int total) {
        // dependency injection of stream controller?

        final currentTime = DateTime.now();
        final elapsedTime = currentTime.difference(startTime).inSeconds;
        if (elapsedTime > 0) {
          final speed = sent / elapsedTime; // bytes per second

          // uploadSpeedNotifier.set(speed.toInt());
          updateSpeed(speed.toInt());
        }
        final progress = sent / total;

        // uploadProgressNotifier.set(progress);
        updateProgress(progress);

        logger.t('Upload progress dio: $progress');
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      updateProgress(0.0);
    });

    logger.i('Upload complete');
  } catch (e) {
    logger.i('Upload failed: $e');
  }
}

class _UploadButtonState extends ConsumerState<UploadButton> {
  bool fileSelectorOpen = false;
  double uploadProgress = 0.0;
  int uploadSpeed = 0;

  void _uploadFile(String filePath, DuktiClient client) async {
    // fileSelectorOpen.set(true);
    // setState(() => fileSelectorOpen2 = true);

    // final result = await FilePicker.platform.pickFiles();

    // // fileSelectorOpen.set(false);
    // setState(() => fileSelectorOpen2 = false);

    // final filePath = '/data/user/0/com.atomar.dukti/cache/file_picker/1733349332034/youtube.apk';

    logger.i('Uploading file: $filePath');

    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'clientId': clientId,
    });

    final address = 'http://${client.ip}:${client.port}/upload';

    logger.i('Uploading to: $address');

    final startTime = DateTime.now();

    try {
      await dio.post(
        address,
        data: formData,
        onSendProgress: (int sent, int total) {
          // dependency injection of stream controller?

          final currentTime = DateTime.now();
          final elapsedTime = currentTime.difference(startTime).inSeconds;
          if (elapsedTime > 0) {
            final speed = sent / elapsedTime; // bytes per second

            // uploadSpeedNotifier.set(speed.toInt());
            if (mounted) setState(() => uploadSpeed = speed.toInt());
          }
          final progress = sent / total;

          // uploadProgressNotifier.set(progress);
          if (mounted) setState(() => uploadProgress = progress);

          logger.t('Upload progress dio: $progress');
        },
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => uploadProgress = 0.0);
        if (mounted) setState(() => uploadSpeed = 0);
      });

      logger.i('Upload complete');
    } catch (e) {
      logger.i('Upload failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.e('Upload progress build: $uploadProgress');

    return uploadProgress == 0.0
        ? FilledButton(
            onPressed: () async {
              final filePath = await pickFile();
              if (filePath != null) {
                _uploadFile(filePath, widget.client);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(fileSelectorOpen ? Colors.grey : Theme.of(context).colorScheme.primary),
            ),
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
            // width: 250,
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
