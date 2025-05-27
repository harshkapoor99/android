import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> compressImage(File file) async {
  try {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final originalSize = file.lengthSync();
    if (kDebugMode) {
      print("Original file size: ${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB");
    }

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
      minWidth: 600,
      minHeight: 600,
    );

    if (result == null) {
      if (kDebugMode) {
        print("Compression failed.");
      }
      return null;
    }

    final compressedFile = File(result.path);
    final compressedSize = compressedFile.lengthSync();
    if (kDebugMode) {
      print("Compressed file size: ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB");
    }

    return compressedFile;
  } catch (e) {
    if (kDebugMode) {
      print('Error during image compression: $e');
    }
    return null;
  }
}
