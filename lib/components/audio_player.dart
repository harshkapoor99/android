// audio_player_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/audio_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';

class AudioPlayerWidget extends ConsumerStatefulWidget {
  final Voice audio;
  final bool isNetworkUrl;
  final Color? waveColor;
  final Color? progressColor;
  final Color? cursorColor;
  final Color? backgroundColor;
  final double? height;

  const AudioPlayerWidget({
    super.key,
    required this.audio,
    this.isNetworkUrl = false,
    this.waveColor,
    this.progressColor,
    this.cursorColor,
    this.backgroundColor,
    this.height = 100,
  });

  @override
  ConsumerState<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends ConsumerState<AudioPlayerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _initializePlayer();
    });
  }

  Future<void> _initializePlayer({required int samples}) async {
    try {
      await ref
          .read(audioPlayerProvider.notifier)
          .preparePlayer(widget.audio, samples: samples);
    } catch (e) {
      AppConstants.showSnackbar(
        message: "Failed to load audio:",
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerProvider);
    final player = ref.read(audioPlayerProvider.notifier);
    final currentDuration = playerState.currentDuration;
    final maxDuration = playerState.playerController.maxDuration;

    final screenWidth = MediaQuery.sizeOf(context).width;

    const style = PlayerWaveStyle(
      fixedWaveColor: Colors.black,
      liveWaveColor: Colors.red,
      showBottom: true,
      showTop: true,
      backgroundColor: Colors.black,
      // waveThickness: 1,
      showSeekLine: true,
      seekLineColor: Colors.yellow,
      scrollScale: 1.5,
    );
    final samples = style.getSamplesForWidth(screenWidth / 3);

    return Container(
      color: widget.backgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Waveform display
          if (widget.audio.id == playerState.selectedVoice?.id)
            SizedBox(
              height: widget.height,
              child:
                  playerState.playerStatus == PlayerStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : AudioFileWaveforms(
                        size: Size(screenWidth / 3, widget.height!),
                        playerController: playerState.playerController,
                        enableSeekGesture: true,
                        waveformType: WaveformType.long,
                        waveformData: playerState.playerController.waveformData,
                        playerWaveStyle: style,

                        // seekLineColor: widget.cursorColor ?? Colors.blue,
                        // waveformStyle: WaveformStyle(
                        //   showMiddleLine: false,
                        //   waveColor: widget.waveColor ?? Colors.grey[400]!,
                        //   progressColor: widget.progressColor ?? Colors.blue,
                        //   showDurationLabel: true,
                        //   durationStyle: TextStyle(
                        //     color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
                        //   ),
                        //   padding: const EdgeInsets.only(top: 16),
                        // ),
                        // onSeek: (duration) {
                        //   player.seekTo(duration);
                        // },
                      ),
            ),

          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  playerState.selectedVoice?.id == widget.audio.id &&
                          playerState.playerStatus == PlayerStatus.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                onPressed: () async {
                  if (playerState.selectedVoice?.id != widget.audio.id) {
                    _initializePlayer(samples: samples);
                    return;
                  }
                  if (playerState.playerStatus == PlayerStatus.playing) {
                    await player.pausePlayer();
                  } else {
                    await player.startPlayer();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () async {
                  await player.stopPlayer();
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () {
                  playerState.playerController.seekTo(
                    playerState.currentDuration - 2,
                  );
                },
              ),
            ],
          ),

          // Position/duration indicator
          if (maxDuration > 0 &&
              playerState.selectedVoice?.id == widget.audio.id)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(Duration(milliseconds: currentDuration)),
                  ),
                  Text(_formatDuration(Duration(milliseconds: maxDuration))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
