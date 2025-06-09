import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guftagu_mobile/components/utility_components/nip_painter.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:lottie/lottie.dart';

class ChatBubbleText extends StatefulWidget {
  final String text;
  final bool isMe;
  final String imageUrl;
  final bool showTyping;
  final DateTime? time;

  const ChatBubbleText({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    this.time,
    this.showTyping = false,
  });

  @override
  State<ChatBubbleText> createState() => _ChatBubbleTextState();
}

class _ChatBubbleTextState extends State<ChatBubbleText> {
  Key textKey = UniqueKey();
  void _deselectText() {
    setState(() {
      textKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: Image.network(widget.imageUrl).image,
                  fit: BoxFit.cover,
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
                  if (!widget.isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: context.colorExt.bubble,
                        isMe: widget.isMe,
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
                          widget.isMe
                              ? const LinearGradient(
                                colors: [Color(0xFF9D00C6), Color(0xFF00B1A4)],
                              )
                              : null,
                      color: widget.isMe ? null : context.colorExt.bubble,
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
                    child: Builder(
                      builder: (context) {
                        if (widget.showTyping) {
                          return Lottie.asset(
                            'assets/animations/du.json',
                            height: 20,
                            fit: BoxFit.contain,
                          );
                        }
                        if (widget.text.isNotEmpty) {
                          return SelectableText(
                            key: textKey,
                            widget.text,
                            style: context.appTextStyle.text.copyWith(
                              fontSize: 14,
                              color:
                                  widget.isMe
                                      ? context.colorExt.buttonText
                                      : context.colorExt.textPrimary,
                              fontStyle: FontStyle.normal,
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
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  if (widget.isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: const Color(0xFF00B1A4),
                        isMe: widget.isMe,
                      ),
                    ),
                ],
              ),

              Text(
                widget.time != null ? formatTime(widget.time!) : "",
                style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
