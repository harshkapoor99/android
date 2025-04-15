import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class ModelCard extends ConsumerWidget {
  const ModelCard({super.key, required this.imageUrl});

  final AssetGenImage imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // NetworkImageWithPlaceholder(
          //   imageUrl: imageUrls[index],
          //   placeholder: Center(
          //     child: SizedBox(
          //       width: 60,
          //       height: 60,
          //       child: Lottie.asset(
          //         Assets.images.logoAnimation,
          //         fit: BoxFit.contain,
          //         width: 5,
          //         height: 5,
          //       ),
          //     ),
          //   ),
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          imageUrl.image(
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
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
                  stops: [0.5, 0.8],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Elina",
                  style: context.appTextStyle.buttonText.copyWith(fontSize: 14),
                ),
                Text(
                  "Perfect girlfriend",
                  style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: CircleAvatar(
              backgroundColor: context.colorExt.border.withValues(alpha: 0.8),
              child: IconButton(
                icon: SvgPicture.asset(
                  Assets.svgs.icChat,
                  width: 15,
                  height: 15,
                ),
                onPressed: () {
                  context.nav.pushNamed(Routes.chat);
                  Future.delayed(
                    Duration(milliseconds: 500),
                    () =>
                        ref
                            .read(isHomeVisitedProvider.notifier)
                            .setHomeViewed(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
