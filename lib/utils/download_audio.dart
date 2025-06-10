import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DownloadedFile {
  DownloadedFile(this.fileName, this.filePath);
  final String fileName;
  final String filePath;
}

Future<DownloadedFile> downloadAudio(String url) async {
  final tempDir = await getTemporaryDirectory();
  final fileName = url.split('/').last.split("?").first;
  final filePath = path.join(tempDir.path, fileName);

  final dio = Dio();
  await dio.download(url, filePath);
  return DownloadedFile(fileName, filePath);
}
