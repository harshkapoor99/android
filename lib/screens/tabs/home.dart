import 'package:flutter/material.dart';

import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/components/model_card.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Widget buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.amber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        height: 170,
        child: Row(
          children: [
            Flexible(
              flex: 45,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Let's create your first character Now!",
                      style: context.appTextStyle.textSemibold.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorExt.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Create Now",
                        style: context.appTextStyle.textSmall.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 40,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Assets.images.imgTrans2.image(
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Assets.images.imgTrans1.image(
                      fit: BoxFit.contain,
                      height: 150,
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
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientText(
            "Explore",
            gradient: LinearGradient(
              colors: [context.colorExt.tertiary, context.colorExt.primary],
              begin: const Alignment(-0.5, -1.5),
              end: const Alignment(1.3, 1.5),
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
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
          const CategoryList(),
          buildCharacterGrid(context),
        ],
      ),
    );
  }
}
