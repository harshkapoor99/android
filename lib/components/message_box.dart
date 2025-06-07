import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    this.controller,
    this.focusNodes,
    required this.hasMessage,
    this.onStarPressed,
    this.onPlusPressed,
  });

  final bool hasMessage;
  final FocusNode? focusNodes;
  final TextEditingController? controller;
  final VoidCallback? onStarPressed;
  final VoidCallback? onPlusPressed;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          isFocused = value;
        });
      },
      child: AnimatedContainer(
        duration: Durations.short2,
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: context.colorExt.surface,
          borderRadius: BorderRadius.circular(
            widget.hasMessage || isFocused ? 10 : 60,
          ),
          border: Border.all(
            color:
                isFocused ? context.colorExt.primary : context.colorExt.surface,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 16,
              width: 16,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Assets.svgs.icChatPrefix,
                height: 16,
                width: 16,
              ),
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: widget.controller,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                focusNode: widget.focusNodes,
                style: context.appTextStyle.text,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 8,
                  ),

                  hintText: "Chat here",
                  hintStyle: context.appTextStyle.textSmall.copyWith(
                    // list item text font size reduced
                    fontSize: 14,
                    color: context.colorExt.textPrimary.withValues(alpha: 0.7),
                  ),
                  fillColor: context.colorExt.surface,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              height: 40,
              width: widget.hasMessage ? 0 : 40,
              duration: const Duration(milliseconds: 100),
              child: IconButton(
                padding: const EdgeInsets.only(right: 8),
                onPressed: widget.onPlusPressed,
                icon: SvgPicture.asset(
                  Assets.svgs.icPlus,
                  height: 28,
                  width: 28,
                  colorFilter: ColorFilter.mode(
                    context.colorExt.textHint,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
