// lib/utils/download_helper.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Downloads the file from the given [url] and saves it with [fileName].
/// Shows SnackBars for success/error, and opens the file when done.
Future<void> downloadAndOpenFile(
    BuildContext context, String url, String fileName) async {
  try {
    // Request storage permission (Android)
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Storage permission not granted")));
        return;
      }
    }

    // Get directory to save the file
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = p.join(directory.path, fileName);

    // Download the file using Dio
    Dio dio = Dio();
    await dio.download(url, filePath, onReceiveProgress: (received, total) {
      if (total != -1) {
        // You can optionally show a progress indicator here.
        print('${(received / total * 100).toStringAsFixed(0)}% downloaded');
      }
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("File downloaded to $filePath")));

    // Open the file for viewing
    await OpenFile.open(filePath);
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Download failed: $e")));
  }
}
