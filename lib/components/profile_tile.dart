import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class ProfileTile extends StatelessWidget {
  final String icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap != null ? 1 : 0.3,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Ink(
          decoration: BoxDecoration(
            color: context.colorExt.surface.withValues(
              alpha: onTap != null ? 1 : 0.3,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap:
                onTap != null
                    ? () => Future.delayed(Durations.short4, onTap)
                    : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 21.29,
                vertical: 10,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(icon, height: 40, width: 42.57),
                  14.pw,
                  Expanded(
                    child: Text(title, style: context.appTextStyle.textBold),
                  ),
                  trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
