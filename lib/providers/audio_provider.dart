// audio_player_provider.dart
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:guftagu_mobile/enums/player_status.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/services/audio_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/download_audio.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/print_debug.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/audio_provider.gen.dart';

@riverpod
class AudioPlayer extends _$AudioPlayer {
  @override
  AudioPlayerState build({Voice? voice, ChatMessage? message}) {
    final initState = AudioPlayerState(playerController: PlayerController());
    initState.playerController.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.playing) {
        state.playerStatus = PlayerStatus.playing;
      } else if (playerState == PlayerState.paused) {
        state.playerStatus = PlayerStatus.paused;
      } else if (playerState == PlayerState.stopped) {
        state.playerStatus = PlayerStatus.stopped;
      }
      // state = state.updateWith(state);
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
          printDebug('Error deleting audio file: $e');
        }
      }
    });
    return initState;
  }

  Future<void> preparePlayerVoice(Voice voice, {int samples = 100}) async {
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
            printDebug('Error deleting audio file: $e');
          }
        }
        final file = await downloadAudio(voiceUrl);
        state.downloadedFilePath = file.filePath;
        state = state.updateWith(state);

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

  Future<void> preparePlayerAudioMessage({
    String? url,
    String? path,
    int samples = 100,
  }) async {
    assert(url != null || path != null, "either url or path must be provided");

    // Stop and clean up previous player if it exists
    if (state.playerStatus != PlayerStatus.stopped) {
      await state.playerController.stopPlayer();
    }

    // Release resources from previous playback
    if (state.downloadedFilePath != null) {
      await state.playerController.release();
    }

    state.playerStatus = PlayerStatus.loading;
    state = state.updateWith(state);

    try {
      // await state.playerController.release();
      // }

      String filePath = "";

      if (path.hasValue) {
        filePath = path!;
      } else if (url.hasValue) {
        final file = await downloadAudio(url!);
        filePath = file.filePath;
      }

      if (filePath.hasValue) {
        state.downloadedFilePath = filePath;
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

  // Future<void> startRecording() async {
  //   if (state.recordController.hasPermission) {
  //     state.recordController.record();
  //   } else {
  //     bool result = await state.recordController.checkPermission();
  //     if (result) {
  //       state.recordController.record();
  //     }
  //   }
  // }

  // void stopRecording() {
  //   if (state.recordController.hasPermission) {
  //     state.recordController.stop();
  //   }
  // }
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

// "/data/user/0/com.guftagu.app.guftagu_mobile/cache/09-06-25-11-14-272541046739822349619.m4a"
// 487163920
