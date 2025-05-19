import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class AnimatedSendButton extends StatelessWidget {
  final bool hasText;
  final VoidCallback onPressed;

  const AnimatedSendButton({
    required this.hasText,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: context.colorExt.border,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child:
              hasText
                  ? SvgPicture.asset(
                    Assets.svgs.icSend,
                    key: const ValueKey("send"),
                  )
                  : SvgPicture.asset(
                    Assets.svgs.icMic,
                    key: const ValueKey("mic"),
                  ),
        ),
      ),
    );
  }
}
