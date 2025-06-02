import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'dart:math' show pi;

class Onboarding extends ConsumerStatefulWidget {
  const Onboarding({super.key});

  @override
  ConsumerState<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends ConsumerState<Onboarding> {
  int selectedIndex = 0;
  final _pageController = PageController(initialPage: 0, viewportFraction: 1);

  late Timer _timer;

  void _schedule() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (selectedIndex < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  void initState() {
    _schedule();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
            offset: const Offset(0, -130),
            child: Transform.rotate(angle: pi / 12.0, child: const ImageGrid()),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: 170,
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),

                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  children: const [
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
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: AnimatedContainer(
                      width: isSelected ? 30 : 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(
                        horizontal: isSelected ? 6 : 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF242424)
                                : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                  );
                }),
              ),
              30.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientButton(
                  title: "Get started",
                  onTap: () {
                    ref
                        .read(hiveServiceProvider.notifier)
                        .setOnboardingValue(value: true);
                    context.nav.pushReplacementNamed(Routes.login);
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

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  final List<AssetGenImage> images = [
    Assets.images.onboarding.obImg1,
    Assets.images.onboarding.obImg2,
    Assets.images.onboarding.obImg3,
    Assets.images.onboarding.obImg4,
    Assets.images.onboarding.obImg5,
    Assets.images.onboarding.obImg6,
    Assets.images.onboarding.obImg7,
    Assets.images.onboarding.obImg8,
    Assets.images.onboarding.obImg9,
    Assets.images.onboarding.obImg10,
    Assets.images.onboarding.obImg11,
    Assets.images.onboarding.obImg12,
  ];

  @override
  void initState() {
    images.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 per row
          crossAxisSpacing: 11,
          mainAxisSpacing: 11,
          childAspectRatio: 0.903,
        ),
        itemBuilder: (context, index) {
          // Determine if this is the middle column
          final isMiddleColumn = index % 3 == 1;
          return Transform.translate(
            offset: Offset(0, isMiddleColumn ? 30 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
