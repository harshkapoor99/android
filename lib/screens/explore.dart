import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/components/model_card.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

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
        height: 150,
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
                        fontSize: 20,
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
                        style: context.appTextStyle.textSemibold.copyWith(
                          fontSize: 12,
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
                      height: 130,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Assets.images.imgTrans1.image(
                      fit: BoxFit.contain,
                      height: 130,
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

  Widget buildCharacterGrid(
    BuildContext context,
    WidgetRef ref,
    List<Character> characters,
  ) {
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
        itemCount: characters.length,
        itemBuilder: (context, index) {
          var image =
              characters[index].imageGallery
                  .where((element) => element.selected == true)
                  .first
                  .url;
          // ignore: unnecessary_null_comparison, prefer_conditional_assignment
          if (image == null) {
            image = characters[index].imageGallery.first.url;
          }
          return ModelCard(
            imageUrl: image,
            name: characters[index].name,
            characterType: null,
            onCharTap:
                () => ref
                    .read(chatProvider.notifier)
                    .setCharacter(characters[index]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterProvider = ref.watch(masterDataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorExt.background,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 30),
              onPressed: () {
                context.nav.pop();
              },
            );
          },
        ),
        title: Row(
          children: [
            const Spacer(),
            SvgPicture.asset(Assets.svgs.icDiamonGold, height: 20),
            5.pw,
            Text(
              '1200',
              style: context.appTextStyle.textBold.copyWith(fontSize: 12),
            ),
            15.pw,
            SvgPicture.asset(Assets.svgs.icNotification, height: 20, width: 20),
            15.pw,
            SvgPicture.asset(Assets.svgs.icSearch, height: 20, width: 20),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(context),
            buildGradientTexts(context),
            const CategoryList(),
            buildCharacterGrid(
              context,
              ref,
              masterProvider.characterDetails
                  .map((c) => c.toCharacter())
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
