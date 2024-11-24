import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '/models/client_name.dart';
import '/models/client_provider.dart';
import '/utils/logger.dart';

class UploadWidget extends StatefulWidget {
  final DuktiClient client;
  const UploadWidget({super.key, required this.client});

  @override
  State<StatefulWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  double _progress = 0.0;

  Future<void> _uploadFile() async {
    setState(() {
      _progress = 0.0;
    });

    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      final dio = Dio();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'clientId': clientId,
      });

      final address = 'http://${widget.client.ip}:${widget.client.port}/upload';

      try {
        await dio.post(
          address,
          data: formData,
          onSendProgress: (int sent, int total) {
            setState(() {
              _progress = sent / total;
            });
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _progress = 0.0;
          });
        });

        logger.i('Upload complete');
      } catch (e) {
        logger.i('Upload failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_progress != 0.0) SizedBox(width: 200, child: LinearProgressIndicator(value: _progress)),
        IconButton(
          onPressed: _uploadFile,
          icon: const Icon(Icons.upload),
        )
      ],
    );
  }
}
