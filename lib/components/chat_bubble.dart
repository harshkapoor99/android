import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final String imageUrl;
  final bool showTyping;
  final DateTime time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.imageUrl,
    required this.time,
    this.showTyping = false,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
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
                      painter: _BubbleNipPainter(
                        color: context.colorExt.sheet,
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
                    child: SelectableText(
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
                    ),
                  ),
                  if (widget.isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: _BubbleNipPainter(
                        color: const Color(0xFF00B1A4),
                        isMe: widget.isMe,
                      ),
                    ),
                ],
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formatTime(widget.time),
                  style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BubbleNipPainter extends CustomPainter {
  final Color? color;
  final bool isMe;

  _BubbleNipPainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color ?? Colors.purple
          ..style = PaintingStyle.fill;

    final path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
