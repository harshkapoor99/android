import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'dart:math' show pi;

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int selectedIndex = 0;
  final _pageController = PageController(initialPage: 0, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 40,
            bottom: 400,
            child: Assets.images.bgGradLarge.image(),
          ),
          Positioned(
            left: 40,
            top: 300,
            child: Assets.images.bgGradSmall.image(),
          ),
          Transform.translate(
            offset: Offset(0, -130.h),
            child: Transform.rotate(angle: pi / 12.0, child: ImageGrid()),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 170.h,
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),

                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  children: [
                    TextContainer(
                      title: "Endless Possibilities",
                      subTitle:
                          "Find solace in the infinite possibilities of AI\na companion who listens, responds, and evolves with you",
                    ),
                    TextContainer(
                      title: "Infinite Fantasy",
                      subTitle:
                          "Enter a realm where imagination has no limits—your dreams, your desires, your rules",
                    ),
                    TextContainer(
                      title: "Emotional Freedom",
                      subTitle:
                          "Build a world where emotions are not just felt but understood, where your deepest desires become real",
                    ),
                  ],
                ),
              ),
              20.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      //   outerCarouselController.animateToPage(index);
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: AnimatedContainer(
                      width: isSelected ? 30.w : 8.w,
                      height: 8.h,
                      margin: EdgeInsets.symmetric(
                        horizontal: isSelected ? 6.w : 3.w,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Color(0xFF242424)
                                : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                  );
                }),
              ),
              30.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GradientButton(
                  title: selectedIndex < 2 ? "Next" : "Get started",
                  onTap: () {
                    if (selectedIndex < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      //   _pageController.animateToPage(
                      //     0,
                      //     duration: Duration(milliseconds: 300),
                      //     curve: Curves.ease,
                      //   );
                      context.nav.pushReplacementNamed(Routes.signup);
                    }
                  },
                ),
              ),
              20.ph,
            ],
          ),
        ],
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  ImageGrid({super.key});
  final List<AssetGenImage> images = [
    Assets.images.img1,
    Assets.images.img2,
    Assets.images.img3,
    Assets.images.img4,
    Assets.images.img5,
    Assets.images.img1,
    Assets.images.img2,
    Assets.images.img3,
    Assets.images.img4,
    Assets.images.img5,
    Assets.images.img1,
    Assets.images.img2,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 per row
          crossAxisSpacing: 11.sp,
          mainAxisSpacing: 11.sp,
          childAspectRatio: 0.903,
        ),
        itemBuilder: (context, index) {
          // Determine if this is the middle column
          final isMiddleColumn = index % 3 == 1;
          return Transform.translate(
            offset: Offset(0, isMiddleColumn ? 30.h : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: images[index].image(fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}

class TextContainer extends StatelessWidget {
  const TextContainer({super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(title, style: context.appTextStyle.title),
        ),
        20.ph,
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              style: context.appTextStyle.textSmall,
            ),
          ),
        ),
      ],
    );
  }
}
