import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/components/model_card.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Widget buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.amber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: SizedBox(
        height: 170.h,
        child: Row(
          children: [
            Flexible(
              flex: 45,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Let's create your first character Now!",
                      style: context.appTextStyle.textSemibold.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.w,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorExt.background,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Create Now",
                        style: context.appTextStyle.textSmall.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 35,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Assets.images.imgTrans2.image(
                      fit: BoxFit.contain,
                      height: 150.h,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Assets.images.imgTrans1.image(
                      fit: BoxFit.contain,
                      height: 150.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGradientTexts(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientText(
            "Explore",
            gradient: LinearGradient(
              colors: [context.colorExt.tertiary, context.colorExt.primary],
              begin: Alignment(-0.5, -1.5),
              end: Alignment(1.3, 1.5),
            ),
            style: context.appTextStyle.subTitle,
          ),
          Text(" AI Characters", style: context.appTextStyle.subTitle),
        ],
      ),
    );
  }

  Widget buildCharacterGrid(BuildContext context) {
    final imageUrls = [
      Assets.images.onboarding.obImg3,
      Assets.images.model.modImg5,
      Assets.images.model.modImg7,
      Assets.images.onboarding.obImg10,
      Assets.images.onboarding.obImg15,
      Assets.images.onboarding.obImg2,
      Assets.images.onboarding.obImg7,
      Assets.images.onboarding.obImg8,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
          childAspectRatio: 0.9,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ModelCard(imageUrl: imageUrls[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(context),
          buildGradientTexts(context),
          CategoryList(),
          buildCharacterGrid(context),
        ],
      ),
    );
  }
}
