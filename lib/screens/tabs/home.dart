import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/components/model_card.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(masterDataProvider.notifier).fetchMasterCharacters();
    });
    super.initState();
  }

  Widget buildHeader(BuildContext context, WidgetRef ref) {
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
              flex: 55,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Let's create your first character Now!",
                        style: context.appTextStyle.textSemibold.copyWith(
                          fontSize: 20,
                          color: context.colorExt.buttonText,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorExt.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            ref.read(tabIndexProvider.notifier).changeTab(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: Text(
                              "Create Now",
                              style: context.appTextStyle.textSemibold.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
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
                    child: Assets.images.exploreRight.image(
                      fit: BoxFit.contain,
                      height: 130,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Assets.images.exploreLeft.image(
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
            description: characters[index].characterDescription,
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
  Widget build(BuildContext context) {
    final masterProvider = ref.watch(masterDataProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(context, ref),
          buildGradientTexts(context),
          const CategoryList(),
          buildCharacterGrid(context, ref, masterProvider.characters),
        ],
      ),
    );
  }
}
