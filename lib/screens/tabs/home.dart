import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

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
                      style: context.appTextStyle.text,
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
                    child: Image.network(
                      "https://s3-alpha-sig.figma.com/img/d8a1/1273/a9d3296cfb0016b4eaaddb5fed31e8c0?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=b3jPtB3s8HK6ekAEFJ5bigzjckaE5KZpql6tbAjrhDq1tqoxGMnCR9u~drXhHZHJkTzGC7FXm3YSR92x~vJt-6bZCYQd~L8r6Kfw1t5WM5ay7AV36M3TcHanxPtJHYEpeMvEauE4JEN1hUSKhUnWTiW0d9-XPL25pTYwauh10Z~~jHUhpOInxGjDzxEfUXP8Le~pZzpLOa8RaUOBSNtYt~WL82YGIWRuYkktmx-tTxpZ-Fh9scLvLJsoCUqgOhQOvzsILkpP49wSgA~dtHKLx1Bo4g-EuIdN6G2jH8Td8F2Be2kdjHkE-~RL8w9Zmkb1n9vibkXpWjaI6QjrN7oOcg__",
                      fit: BoxFit.contain,
                      height: 150.h,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.network(
                      "https://s3-alpha-sig.figma.com/img/45ba/af80/ac608ea304992507ef8139044ce426e1?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=AH1nqh9EvrKj8KFSrj6GG90lzK3OnA7y1kcR2NNF7GXBLeObXTSuLLAenz7pvVXpR3kz4JcoZkclHvdHgqQkVHErA6sltr4sCJ2K6U1sltPKlSLEcyMiBeKX3mhYzZiG64p4IIBFxrvrF7WRAqLOU3AiBRGxbIOxG96xbbuFhJypJcxCoceRbGOJ3eklt2AteSxulVh5DI3c6nioPgosYDZT-SIPWHk08V-XraqpcAWZtFVp~LFq-fqs4jfxfNcwxlgg8lNyAC7OL7AaIUOFGdxA~DMZxBNtvJIoX7-ISXYdbbDVu5BU0M0pCbkhIIciTuhn1SprNcKhUZCtC0APQA__",
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
                child: Text(
                  category,
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
          );
        },
      ),
    );
  }

  Widget buildCharacterGrid() {
    final imageUrls = [
      Assets.images.img1,
      Assets.images.img2,
      Assets.images.img3,
      Assets.images.img4,
      Assets.images.img1,
      Assets.images.img2,
      Assets.images.img3,
      Assets.images.img4,
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
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                imageUrls[index].image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: SvgPicture.asset(Assets.svgs.icChat),
                      onPressed: widget.startChat,
                    ),
                  ),
                ),
              ],
            ),
          );
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
