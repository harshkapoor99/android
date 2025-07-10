import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class ChatBubbleCallMessage extends StatefulWidget {
  final String text;
  final bool isMe, isFirst, isLast;
  final String imageUrl;
  final DateTime? time;

  const ChatBubbleCallMessage({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    this.isFirst = false,
    this.isLast = false,
    this.time,
  });

  @override
  State<ChatBubbleCallMessage> createState() => _ChatBubbleCallMessageState();
}

class _ChatBubbleCallMessageState extends State<ChatBubbleCallMessage> {
  Key textKey = UniqueKey();
  void _deselectText() {
    setState(() {
      textKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: context.colorExt.primary.withAlpha(35),
        borderRadius: BorderRadius.only(
          bottomLeft: widget.isFirst ? const Radius.circular(10) : Radius.zero,
          bottomRight: widget.isFirst ? const Radius.circular(10) : Radius.zero,
          topLeft: widget.isLast ? const Radius.circular(10) : Radius.zero,
          topRight: widget.isLast ? const Radius.circular(10) : Radius.zero,
        ),
      ),
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isMe)
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 15),

              width: 30,
              height: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: NetworkImageWithPlaceholder(
                  imageUrl: widget.imageUrl,
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
                widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // if (!widget.isMe)
                  //   CustomPaint(
                  //     size: const Size(6, 6),
                  //     painter: BubbleNipPainter(
                  //       color: context.colorExt.bubble,
                  //       isMe: widget.isMe,
                  //     ),
                  //   ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      // gradient:
                      //     widget.isMe
                      //         ? const LinearGradient(
                      //           colors: [
                      //             Color(0xFF9D00C6),
                      //             Color(0xFF00B1A4),
                      //           ],
                      //         )
                      //         : null,
                      // color: widget.isMe ? null : context.colorExt.bubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(widget.isMe ? 10 : 0),
                        bottomRight: Radius.circular(widget.isMe ? 0 : 10),
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: SelectableText(
                      key: textKey,
                      widget.text,
                      style: context.appTextStyle.text.copyWith(
                        fontSize: 14,
                        color:
                            widget.isMe
                                ? context.colorExt.buttonText
                                : context.colorExt.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                      contextMenuBuilder: (context, editableTextState) {
                        final selectedText = editableTextState
                            .textEditingValue
                            .selection
                            .textInside(widget.text);
                        return AdaptiveTextSelectionToolbar.buttonItems(
                          buttonItems: [
                            if (selectedText.isNotEmpty)
                              ContextMenuButtonItem(
                                label: 'Copy',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: selectedText),
                                  );
                                  _deselectText();
                                },
                              ),
                            ContextMenuButtonItem(
                              label: 'Copy All',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: widget.text),
                                );
                                _deselectText();
                              },
                            ),
                          ],
                          anchors: TextSelectionToolbarAnchors(
                            primaryAnchor:
                                editableTextState
                                    .contextMenuAnchors
                                    .primaryAnchor -
                                const Offset(0, 0),
                          ),
                        );
                      },
                    ),
                  ),
                  //   if (widget.isMe)
                  //     CustomPaint(
                  //       size: const Size(6, 6),
                  //       painter: BubbleNipPainter(
                  //         color: const Color(0xFF00B1A4),
                  //         isMe: widget.isMe,
                  //       ),
                  //     ),
                ],
              ),

              // Text(
              //   widget.time != null ? formatTime(widget.time!) : "",
              //   style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
