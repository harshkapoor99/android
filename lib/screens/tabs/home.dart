import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:lottie/lottie.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.startChat});
  final VoidCallback startChat;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategoryTab = "";

  void selectCategoryTab(String tab) {
    setState(() {
      selectedCategoryTab = tab;
    });
  }

  Widget buildHeader() {
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

  Widget buildGradientTexts() {
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

  Widget buildCategoryTabs() {
    final categories = [
      "Lover",
      "Sports",
      "Girlfriend",
      "Bollywood",
      "Fashion",
      "Villain",
      "Comedian",
      "Anime",
      "Gamer",
      "Celebrity",
      "Sci-Fi",
      "Horror",
      "Superhero",
      "Historical",
    ];

    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected = category == selectedCategoryTab;

          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 8.0.w : 0,
            ),
            child: GestureDetector(
              onTap: () => selectCategoryTab(category),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFB1B0BD) : Color(0xFF23222F),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: AppTextStyle(context).textSemibold.copyWith(
                      color:
                          isSelected
                              ? context.colorExt.background
                              : context.colorExt.textPrimary.withValues(
                                alpha: 0.6,
                              ),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCharacterGrid() {
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
          return ModelCard(imageUrl: imageUrls[index], widget: widget);
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
          buildHeader(),
          buildGradientTexts(),
          buildCategoryTabs(),
          buildCharacterGrid(),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;

  const CategoryItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
