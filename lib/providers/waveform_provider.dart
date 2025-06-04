// waveform_provider.dart

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part '../gen/providers/waveform_provider.gen.dart';

@riverpod
class WaveformController extends _$WaveformController {
  @override
  WaveFormState build() {
    var waveformController = PlayerController();

    final initState = WaveFormState(waveformController: waveformController);

    // Dispose
    ref.onDispose(() {
      initState.waveformController.dispose();
      // Clean up downloaded file
      if (initState.downloadedFilePath != null) {
        try {
          final file = File(initState.downloadedFilePath!);
          if (file.existsSync()) {
            file.deleteSync();
          }
        } catch (e) {
          print('Error deleting audio file: $e');
        }
      }
    });

    return initState;
  }

  Future<void> _downloadAudio(String url) async {
    // Check storage permission
    // final hasStorage = await hasStoragePermission();

    // // if (!hasStorage) {
    // //   throw Exception('Storage permission not granted');
    // // }
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      state.downloadedFilePath = path.join(tempDir.path, fileName);

      final dio = Dio();
      await dio.download(
        url,
        state.downloadedFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            print('Download progress: $progress%');
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> prepareWaveform(String audioPath, bool isNetworkUrl) async {
    try {
      String filePath = audioPath;

      if (isNetworkUrl) {
        await _downloadAudio(audioPath);
        filePath = state.downloadedFilePath!;
      }

      // final tempDir = await getTemporaryDirectory();
      // final waveformPath = path.join(
      //   tempDir.path,
      //   'waveform_${DateTime.now().millisecondsSinceEpoch}.json',
      // );

      await state.waveformController.preparePlayer(
        path: filePath,
        shouldExtractWaveform: true,

        // waveformData: WaveformData(path: waveformPath, samples: []),
      );
    } catch (e) {
      print('Error preparing waveform: $e');
      rethrow;
    }
  }
}

class WaveFormState {
  WaveFormState({required this.waveformController, this.downloadedFilePath});

  PlayerController waveformController;
  String? downloadedFilePath;
}
