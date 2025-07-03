import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/utility_components/nip_painter.dart';
import 'package:guftagu_mobile/enums/chat_type.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/file_name_form_url.dart';
import 'package:guftagu_mobile/utils/file_type_from_mime.dart';
import 'package:mime/mime.dart';

class ChatBubbleFile extends ConsumerWidget {
  final ChatMessage message;
  final bool isMe;
  final String imageUrl;
  final DateTime? time;
  final String? path;
  final String? url;

  const ChatBubbleFile({
    super.key,
    required this.message,
    required this.isMe,
    required this.imageUrl,
    this.time,
    this.path,
    this.url,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: NetworkImageWithPlaceholder(
                  imageUrl: imageUrl,
                  placeholder: SvgPicture.asset(
                    Assets.svgs.icProfilePlaceholder,
                  ),
                  fit: BoxFit.cover,
                  errorWidget: SvgPicture.asset(
                    Assets.svgs.icProfilePlaceholder,
                  ),
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
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: context.colorExt.bubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(isMe ? 10 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 10),
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
                    child: Column(
                      crossAxisAlignment:
                          isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: context.colorExt.primary.withAlpha(50),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              message.chatType == ChatType.image.name
                                  ? const Icon(Icons.image, size: 30)
                                  : const Icon(
                                    Icons.file_present_rounded,
                                    size: 30,
                                  ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.fileName ??
                                          getFileNameFromUrl(url ?? ""),
                                      style: context.appTextStyle.textSmall,
                                      overflow: TextOverflow.fade,
                                    ),
                                    Text(
                                      getFileTypeFromMime(
                                        lookupMimeType(
                                          message.fileName ??
                                              path ??
                                              getFileNameFromUrl(url ?? ""),
                                        ),
                                      ),
                                      style: context.appTextStyle.textSmall
                                          .copyWith(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (message.message.hasValue)
                          Text(
                            message.message!,
                            style: context.appTextStyle.textSmall,
                          ),
                      ],
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

              // Text(
              //   "Duration ${(playerState.playerController.maxDuration / 1000).floor()}",
              // ),
              // Text(
              //   "ph${provider.messageId} pch${playerState.playerController.hashCode} wfh${playerState.playerController.waveformData.hashCode}",
              // ),
              // Text(
              //   "ph${provider.hashCode} plh${player.hashCode} psh${playerState.hashCode}",
              // ),
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
