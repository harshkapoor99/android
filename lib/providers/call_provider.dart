import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recorder/flutter_recorder.dart';
import 'package:guftagu_mobile/enums/player_status.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/services/chat_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/download_audio.dart';
import 'package:guftagu_mobile/utils/print_debug.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/call_provider.gen.dart';

const double minumumDecibal = -27.0;

@Riverpod(keepAlive: true)
// @riverpod
class Call extends _$Call {
  @override
  CallState build() {
    final CallState initialState = CallState(
      recorder: Recorder.instance,
      player: PlayerController(),
    );

    initialState.player.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.playing) {
        state.playerStatus = PlayerStatus.playing;
      } else if (playerState == PlayerState.paused) {
        state.playerStatus = PlayerStatus.paused;
      } else if (playerState == PlayerState.stopped) {
        state.playerStatus = PlayerStatus.stopped;
        // Start recording only after player has stopped
        if (state.isCallStarted &&
            state.recordPath != null &&
            !state.inFlight) {
          // state.recorder.startRecording(completeFilePath: state.recordPath!);
          // state.isRecording = true;
          // state = state._updateWith(state);
        }
      }
      state = state._updateWith(state);
    });

    ref.onDispose(() {
      initialState.player.dispose();
    });

    return initialState;
  }

  void toggleSpeaker() {
    state.isSpeakerOn = !state.isSpeakerOn;
    state = state._updateWith(state);
  }

  void setCharacter(Character character) {
    state.character = character;
    state = state._updateWith(state);
    startCall();
  }

  void startCall() async {
    await Permission.microphone.request().isGranted.then((value) async {
      if (!value) {
        await [Permission.microphone].request();
      }
    });

    const format = PCMFormat.f32le;
    const sampleRate = 22050;
    const channels = RecorderChannels.mono;
    await state.recorder.init(
      format: format,
      sampleRate: sampleRate,
      channels: channels,
    );
    state.recorder.setSilenceThresholdDb(state.minimumDecibal);
    state.recorder.setSilenceDuration(1.5);
    state.recorder.setSecondsOfAudioToWriteBefore(0.0);
    state.recorder.setSilenceDetection(
      enable: true,
      onSilenceChanged: (isSilent, decibel) async {
        /// Here you can check if silence is changed.
        /// Or you can do the same thing with the Stream
        /// [Recorder.instance.silenceChangedEvents]
        printDebug("isSilent: $isSilent $decibel");
        state.isSilent = isSilent;
        state.decibel = decibel;
        state = state._updateWith(state);
        if (!state.inFlight &&
            state.playerStatus != PlayerStatus.playing &&
            state.recordPath != null &&
            state.isRecording) {
          if (isSilent) {
            if (state.decibel != 0 && decibel < minumumDecibal) {
              var avgDecibel = (state.minimumDecibal + decibel) / 2;
              if (avgDecibel > minumumDecibal) {
                state.minimumDecibal = avgDecibel;
                state.recorder.setSilenceThresholdDb(avgDecibel);
              }
            }
            state.recorder.stopRecording();
            state.isRecording = false;
            await state.player.stopPlayer();
            // await state.player.release();
            state.inFlight = true;
            state = state._updateWith(state);
            final response = await ref
                .read(chatServiceProvider)
                .voiceCall(
                  audioFile: File(state.recordPath!),
                  sessionId:
                      state.character!.id +
                      ref.read(hiveServiceProvider.notifier).getUserId()!,
                  characterId: state.character!.id,
                  creatorId:
                      ref.read(hiveServiceProvider.notifier).getUserId()!,
                );
            try {
              final file = await writeToFile(response.data);
              await state.player.preparePlayer(path: file.filePath);
              state.player.setFinishMode(finishMode: FinishMode.stop);
              if (state.isCallStarted) {
                print("Playing Audio");
                state.player.startPlayer();
              }
            } catch (e) {
              rethrow;
            } finally {
              state.inFlight = false;
              state = state._updateWith(state);
            }
          }
        } else {
          // Only start recording if player is not playing or paused
          if (state.playerStatus == PlayerStatus.stopped &&
              state.recordPath != null) {
            state.recorder.startRecording(completeFilePath: state.recordPath!);
            state.isRecording = true;
            state = state._updateWith(state);
          }
        }
      },
    );
    state.recorder.start();
    await Future.delayed(const Duration(seconds: 2));

    final tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/flutter_recorder.wav';

    state.recordPath = filePath;
    // Do not start recording here; it will be started after player stops
    state.recorder.startRecording(completeFilePath: filePath);
    state.isRecording = true;

    state.isCallStarted = true;
    state.callStartTime = DateTime.now();
    state = state._updateWith(state);
  }

  void stopCall() async {
    state.recorder.stopRecording();
    state.recorder.stop();
    state.recorder.deinit();
    state.player.stopAllPlayers();
    state.inFlight = false;
    state.callStartTime = null;
    state = state._updateWith(state);
    await Future.delayed(Durations.extralong4 * 1000, () {
      state.isCallStarted = false;
      state._updateWith(state);
    });
  }
}

class CallState {
  CallState({
    required this.recorder,
    required this.player,
    this.inFlight = false,
    this.isSpeakerOn = false,
    this.isSilent = true,
    this.isRecording = false,
    this.character,
    this.isCallStarted = false,
    this.recordPath,
    this.decibel = 0,
    this.minimumDecibal = -27,
    this.playerStatus = PlayerStatus.idle,
    this.callStartTime,
  });

  bool isSpeakerOn, isCallStarted, isSilent, inFlight, isRecording;
  double decibel;
  double minimumDecibal;
  String? recordPath;
  Character? character;
  final Recorder recorder;
  final PlayerController player;
  PlayerStatus playerStatus;
  DateTime? callStartTime;

  CallState _updateWith(CallState state) {
    return CallState(
      recorder: state.recorder,
      player: state.player,
      inFlight: state.inFlight,
      isSpeakerOn: state.isSpeakerOn,
      isRecording: state.isRecording,
      isCallStarted: state.isCallStarted,
      character: state.character,
      decibel: state.decibel,
      minimumDecibal: state.minimumDecibal,
      isSilent: state.isSilent,
      recordPath: state.recordPath,
      playerStatus: state.playerStatus,
      callStartTime: state.callStartTime,
    );
  }
}
