import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:lottie/lottie.dart';

class ModelCard extends ConsumerWidget {
  const ModelCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.characterType,
    required this.onCharTap,
  });

  final String imageUrl;
  final String name;
  final String? characterType;
  final void Function() onCharTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          NetworkImageWithPlaceholder(
            imageUrl: imageUrl,
            placeholder: Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: Lottie.asset(
                  Assets.animations.logo,
                  fit: BoxFit.contain,
                  width: 5,
                  height: 5,
                ),
              ),
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // imageUrl.image(
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Align(
            alignment: Alignment.bottomCenter,

            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  stops: const [0.5, 0.8],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: context.appTextStyle.buttonText.copyWith(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        // if (persionality.hasValue)
                        if (characterType != null)
                          Text(
                            characterType!,
                            style: context.appTextStyle.text.copyWith(
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(
                      0xFF414141,
                    ).withValues(alpha: 0.6),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        Assets.svgs.icChat,
                        width: 15,
                        height: 15,
                      ),
                      onPressed: () {
                        onCharTap();
                        context.nav.pushNamed(Routes.chat);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
