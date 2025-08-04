import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DownloadedFile {
  DownloadedFile(this.fileName, this.filePath);
  final String fileName;
  final String filePath;
}

Future<DownloadedFile> downloadAssetFromUrl(String url) async {
  final tempDir = await getTemporaryDirectory();
  final fileName = url.split('/').last.split("?").first;
  final filePath = path.join(tempDir.path, fileName);

  final dio = Dio();
  await dio.download(url, filePath);
  return DownloadedFile(fileName, filePath);
}

Future<DownloadedFile> writeToFile(List<int> data) async {
  final tempDir = await getTemporaryDirectory();
  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final filePath = path.join(tempDir.path, fileName);
  File file = File(filePath);
  var raf = file.openSync(mode: FileMode.write);
  // response.data is List<int> type
  raf.writeFromSync(data);
  await raf.close();
  return DownloadedFile(fileName, filePath);
}
