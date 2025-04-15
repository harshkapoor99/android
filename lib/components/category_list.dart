import 'package:flutter/material.dart';

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
      height: 30,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected = category == selectedCategoryTab;

          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 8.0 : 0,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFB1B0BD) : Color(0xFF23222F),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color:
                    Colors
                        .transparent, // Important for InkWell to work properly
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => selectCategoryTab(category),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                          fontSize: 12,
                        ),
                      ),
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
