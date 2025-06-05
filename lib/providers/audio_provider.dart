// audio_player_provider.dart
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/services/audio_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/audio_provider.gen.dart';

enum PlayerStatus { stopped, playing, paused, loading, error }

@riverpod
class AudioPlayer extends _$AudioPlayer {
  @override
  AudioPlayerState build() {
    final initState = AudioPlayerState(playerController: PlayerController());
    initState.playerController.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.playing) {
        state.playerStatus = PlayerStatus.playing;
      } else if (playerState == PlayerState.paused) {
        state.playerStatus = PlayerStatus.paused;
      } else if (playerState == PlayerState.stopped) {
        state.playerStatus = PlayerStatus.stopped;
      }
      state = state.updateWith(state);
    });

    initState.playerController.onCurrentDurationChanged.listen((duration) {
      state.currentDuration = duration;
      state = state.updateWith(state);
    });

    ref.onDispose(() {
      state.playerController.dispose();
      // Clean up downloaded file
      if (state.downloadedFilePath != null) {
        try {
          final file = File(state.downloadedFilePath!);
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
    // final status = await Permission.storage.request();
    // if (!status.isGranted) {
    //   throw Exception('Storage permission not granted');
    // }

    final tempDir = await getTemporaryDirectory();
    final fileName = url.split('/').last.split("?").first;
    state.downloadedFilePath = path.join(tempDir.path, fileName);
    state = state.updateWith(state);

    final dio = Dio();
    await dio.download(url, state.downloadedFilePath!);
    print("#AP> download complete");
  }

  Future<void> preparePlayer(Voice voice, {int samples = 100}) async {
    // Skip if we're already preparing/playing the same voice
    if (state.selectedVoice?.id == voice.id &&
        state.playerStatus != PlayerStatus.stopped) {
      return;
    }

    // Stop and clean up previous player if it exists
    if (state.playerStatus != PlayerStatus.stopped) {
      await state.playerController.stopPlayer();
    }

    // Release resources from previous playback
    if (state.downloadedFilePath != null) {
      await state.playerController.release();
    }

    state.selectedVoice = voice;
    state.playerStatus = PlayerStatus.loading;
    state = state.updateWith(state);

    final res = await ref
        .read(audioServiceProvider)
        .generateAudio(
          text:
              "Hello, ${ref.read(hiveServiceProvider.notifier).getUserInfo()?.profile.fullName ?? ""}! It's nice to meet you! How are you?",
          languageId: voice.languageId,
          vocalId: voice.vocalId,
        );

    final String voiceUrl = res.data["tts_audio_url"];

    state.currentPath = voiceUrl;
    state = state.updateWith(state);

    try {
      if (voiceUrl.hasValue) {
        String filePath = voiceUrl;

        if (state.downloadedFilePath != null) {
          try {
            final file = File(state.downloadedFilePath!);
            if (file.existsSync()) {
              file.deleteSync();
            }
          } catch (e) {
            print('Error deleting audio file: $e');
          }
        }
        await _downloadAudio(voiceUrl);
        filePath = state.downloadedFilePath!;
        await state.playerController.preparePlayer(
          path: filePath,
          shouldExtractWaveform: true,
          noOfSamples: samples,
        );
        state.playerController.setFinishMode(finishMode: FinishMode.pause);

        // state.playerStatus = PlayerStatus.stopped;
        state.playerController.startPlayer();
        state = state.updateWith(state);
      }
    } catch (e) {
      state.playerStatus = PlayerStatus.error;
      state = state.updateWith(state);
      rethrow;
    }
  }

  Future<void> startPlayer() async {
    await state.playerController.startPlayer();
  }

  Future<void> pausePlayer() async {
    await state.playerController.pausePlayer();
  }

  Future<void> stopPlayer() async {
    await state.playerController.stopPlayer();
  }

  Future<void> seekTo(Duration duration) async {
    await state.playerController.seekTo(duration.inMilliseconds);
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

      await state.playerController.preparePlayer(
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

class AudioPlayerState {
  AudioPlayerState({
    required this.playerController,
    this.selectedVoice,
    this.currentDuration = 0,
    this.currentPath,
    this.downloadedFilePath,
    this.playerStatus = PlayerStatus.stopped,
  });
  Voice? selectedVoice;
  PlayerController playerController;
  String? currentPath;
  String? downloadedFilePath;
  PlayerStatus playerStatus;
  int currentDuration;

  AudioPlayerState updateWith(AudioPlayerState state) => AudioPlayerState(
    playerController: state.playerController,
    selectedVoice: state.selectedVoice,
    currentPath: state.currentPath,
    downloadedFilePath: state.downloadedFilePath,
    playerStatus: state.playerStatus,
    currentDuration: state.currentDuration,
  );
}
