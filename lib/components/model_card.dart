import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/screens/tabs/home.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class ModelCard extends StatelessWidget {
  const ModelCard({super.key, required this.imageUrl, required this.widget});

  final AssetGenImage imageUrl;
  final HomeTab widget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // NetworkImageWithPlaceholder(
          //   imageUrl: imageUrls[index],
          //   placeholder: Center(
          //     child: SizedBox(
          //       width: 60.w,
          //       height: 60.w,
          //       child: Lottie.asset(
          //         Assets.images.logoAnimation,
          //         fit: BoxFit.contain,
          //         width: 5.w,
          //         height: 5.w,
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
            bottom: 12.h,
            left: 12.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Elina",
                  style: context.appTextStyle.buttonText.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  "Perfect girlfriend",
                  style: context.appTextStyle.textSmall.copyWith(
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12.h,
            right: 12.h,
            child: CircleAvatar(
              backgroundColor: context.colorExt.border.withValues(alpha: 0.8),
              child: IconButton(
                icon: SvgPicture.asset(
                  Assets.svgs.icChat,
                  width: 15.w,
                  height: 15.w,
                ),
                onPressed: widget.startChat,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
