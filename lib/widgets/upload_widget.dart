import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '/models/client_name.dart';
import '/models/client_provider.dart';
import '/utils/logger.dart';

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

class _UploadButtonState extends ConsumerState<UploadButton> {
  bool fileSelectorOpen = false;
  double uploadProgress = 0.0;
  int uploadSpeed = 0;
  bool stopUpload = false;
  CancelToken cancelToken = CancelToken();

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
        cancelToken: cancelToken,
        address,
        data: formData,
        onSendProgress: (int sent, int total) async {
          final currentTime = DateTime.now();
          final elapsedTime = currentTime.difference(startTime).inSeconds;
          if (elapsedTime > 0) {
            final speed = sent / elapsedTime; // bytes per second

            if (mounted) setState(() => uploadSpeed = speed.toInt());
          }
          final progress = sent / total;

          if (mounted) setState(() => uploadProgress = progress);
        },
      );

      /// Wait for the progress bar to reach 100% before resetting it after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            uploadProgress = 0.0;
            uploadSpeed = 0;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('The upload succeeded'),
            ));
          });
        }
      });

      logger.i('Upload complete');
    } catch (e) {
      String errorText = 'The upload failed';
      if (cancelToken.isCancelled) {
        errorText = 'The upload was cancelled';
        cancelToken = CancelToken();
      }
      logger.e('Upload failed: $e');

      /// Show an error message if the upload fails
      if (mounted) {
        setState(() {
          uploadProgress = 0.0;
          uploadSpeed = 0;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorText),
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // logger.e('Upload progress build: $uploadProgress');

    return uploadProgress == 0.0
        ? FilledButton(
            onPressed: () async {
              final filePath = await pickFile();
              if (filePath != null) {
                try {
                  _uploadFile(filePath, widget.client);
                } catch (e) {
                  logger.e('Upload failed: $e');
                }
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
                Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: () => cancelToken.cancel(), icon: Icon(Icons.clear))),
              ],
            ),
          );
  }
}
