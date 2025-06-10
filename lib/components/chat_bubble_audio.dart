import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/utility_components/nip_painter.dart';
import 'package:guftagu_mobile/enums/player_status.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';
import 'package:guftagu_mobile/providers/audio_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:lottie/lottie.dart';

class ChatBubbleAudio extends ConsumerWidget {
  final ChatMessage message;
  final bool isMe;
  final String imageUrl;
  final bool showTyping;
  final DateTime? time;
  final String? path;
  final String? url;

  const ChatBubbleAudio({
    super.key,
    required this.message,
    required this.isMe,
    required this.imageUrl,
    this.time,
    this.showTyping = false,
    this.path,
    this.url,
  });

  Future<void> initializePlayer(
    BuildContext context,
    WidgetRef ref, {
    required int samples,
  }) async {
    try {
      await ref
          .read(audioPlayerProvider(message: message).notifier)
          .preparePlayerAudioMessage(path: path, url: url, samples: samples);
    } catch (e) {
      AppConstants.showSnackbar(
        message: "Failed to load audio",
        isSuccess: false,
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider(message: message));
    final player = ref.read(audioPlayerProvider(message: message).notifier);

    final screenWidth = MediaQuery.sizeOf(context).width;
    print(
      "re-building player ${player.hashCode}, controller ${playerState.playerController.hashCode}",
    );

    final samples = AppConstants.playerWaveStyle.getSamplesForWidth(
      screenWidth / 5,
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 15),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: Image.network(imageUrl).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: context.colorExt.bubble,
                        isMe: isMe,
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      // gradient:
                      //     isMe
                      //         ? const LinearGradient(
                      //           colors: [Color(0xFF9D00C6), Color(0xFF00B1A4)],
                      //         )
                      //         : null,
                      // color: isMe ? null : context.colorExt.bubble,
                      color: context.colorExt.bubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(isMe ? 10 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 10),
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
                    child: Builder(
                      builder: (context) {
                        if (showTyping) {
                          return Lottie.asset(
                            'assets/animations/du.json',
                            height: 20,
                            fit: BoxFit.contain,
                          );
                        }
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (playerState.downloadedFilePath == null) {
                                  initializePlayer(
                                    context,
                                    ref,
                                    samples: samples,
                                  );
                                  return;
                                }
                                if (playerState.playerStatus ==
                                    PlayerStatus.playing) {
                                  await player.pausePlayer();
                                } else {
                                  await player.startPlayer();
                                }
                              },
                              child: SvgPicture.asset(
                                playerState.playerStatus == PlayerStatus.playing
                                    ? Assets.svgs.icPause
                                    : Assets.svgs.icPlay,
                              ),
                            ),
                            Expanded(
                              child: ColoredBox(
                                color: Colors.green,
                                child: AudioFileWaveforms(
                                  size: Size(screenWidth / 2, 40),

                                  playerController:
                                      playerState.playerController,
                                  enableSeekGesture: true,
                                  waveformType: WaveformType.fitWidth,
                                  waveformData:
                                      playerState.playerController.waveformData,
                                  playerWaveStyle: AppConstants.playerWaveStyle,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  if (isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: context.colorExt.bubble,
                        isMe: isMe,
                      ),
                    ),
                ],
              ),

              Text(
                time != null ? formatTime(time!) : "",
                style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
