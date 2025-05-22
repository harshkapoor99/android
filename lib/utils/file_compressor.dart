import 'dart:io';

import 'package:flutter/foundation.dart';

Future<File?> compressImage(File file) async {
  try {
    int percentage = 100;
    File? compressedFile;
    int sizeInBytes = File(file.path).lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    // while (sizeInMb > 2) {
    //   percentage = percentage - 20;
    //   compressedFile = await FlutterNativeImage.compressImage(
    //     file.path,
    //     quality: 70,
    //     percentage: percentage,
    //   );
    //   int sizeInBytes = File(compressedFile.path).lengthSync();
    //   sizeInMb = sizeInBytes / (1024 * 1024);
    // }
    return File(compressedFile?.path ?? file.path);
  } catch (e) {
    if (kDebugMode) {
      print('--error--$e');
    }
    return null; //If any error occurs during compression, the process is stopped.
  }
}