import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/utility_components/nip_painter.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:lottie/lottie.dart';

class ChatBubbleTyping extends StatelessWidget {
  final bool isMe;
  final String imageUrl;

  const ChatBubbleTyping({
    super.key,
    required this.isMe,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          isMe
                              ? const LinearGradient(
                                colors: [Color(0xFF9D00C6), Color(0xFF00B1A4)],
                              )
                              : null,
                      color: isMe ? null : context.colorExt.bubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(isMe ? 10 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 10),
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Lottie.asset(
                      'assets/animations/du.json',
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: const Color(0xFF00B1A4),
                        isMe: isMe,
                      ),
                    ),
                ],
              ),
              Text(
                "",
                style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
