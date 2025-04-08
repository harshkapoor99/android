import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String selectedCategoryTab = "";

  void selectCategoryTab(String tab) {
    setState(() {
      selectedCategoryTab = tab;
    });
  }

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

  @override
  Widget build(BuildContext context) {
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
                    style: context.appTextStyle.textSemibold.copyWith(
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
}
