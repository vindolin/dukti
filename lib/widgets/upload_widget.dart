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

class UploadWidget extends ConsumerWidget {
  final DuktiClient client;
  const UploadWidget({super.key, required this.client});

  Future<void> _uploadFile(WidgetRef ref) async {
    final uploadProgressNotifier = ref.read(uploadProgressProvider.notifier);

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

      try {
        await dio.post(
          address,
          data: formData,
          onSendProgress: (int sent, int total) {
            uploadProgressNotifier.set(sent / total);
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          uploadProgressNotifier.set(0.0);
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
    return Row(
      children: [
        if (uploadProgress != 0.0) SizedBox(width: 200, child: LinearProgressIndicator(value: uploadProgress)),
        IconButton(
          onPressed: () => _uploadFile(ref),
          icon: const Icon(Icons.upload),
        )
      ],
    );
  }
}
