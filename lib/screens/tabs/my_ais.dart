import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/gradient_text.dart';
import 'package:guftagu_mobile/components/model_card.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/providers/my_ai_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class MyAisTab extends ConsumerStatefulWidget {
  const MyAisTab({super.key});

  @override
  ConsumerState<MyAisTab> createState() => _MyAisTabState();
}

class _MyAisTabState extends ConsumerState<MyAisTab> {
  @override
  void initState() {
    ref.read(myAiProvider.notifier).fetchMyAis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(myAiProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(myAiProvider.notifier).fetchMyAis();
      },
      child:
          provider.isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      Assets.animations.logo,
                      width: 200,
                      height: 200,
                      animate: false,
                    ),
                    const Text(
                      "Gathering your characters...",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : provider.myAiList.isEmpty
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GradientTextWidgets(
                              [
                                Text(
                                  "IMAGINE",
                                  style: context.appTextStyle.textBold.copyWith(
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  "THE",
                                  style: context.appTextStyle.textSemibold
                                      .copyWith(fontSize: 24),
                                ),
                                Text(
                                  "POSSIBILITIES",
                                  style: context.appTextStyle.textBold.copyWith(
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  context.colorExt.tertiary,
                                  context.colorExt.primary,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),
                        50.ph,
                        Text(
                          "Create your very own Character AI and bring your ideas to life.",
                          textAlign: TextAlign.center,
                          style: context.appTextStyle.subTitle,
                        ),
                        30.ph,
                        Text(
                          "Discover the joy of creation in the create tab.",
                          textAlign: TextAlign.center,
                          style: context.appTextStyle.text,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                          width: MediaQuery.sizeOf(context).width / 4,
                          Assets.svgs.icSwirlArrow,
                          colorFilter: ColorFilter.mode(
                            context.colorExt.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 26),
                    const Text(
                      'My AIs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF2F2F2),
                      ),
                    ),
                    const SizedBox(height: 18),
                    GridView.builder(
                      // crossAxisCount: 2,
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      // mainAxisSpacing: 10,
                      // crossAxisSpacing: 10,
                      // childAspectRatio: 127.72 / 131,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: provider.myAiList.length,
                      itemBuilder: (context, index) {
                        var image =
                            provider.myAiList[index].imageGallery
                                .where((element) => element.selected == true)
                                .first
                                .url;
                        // ignore: unnecessary_null_comparison, prefer_conditional_assignment
                        if (image == null) {
                          image =
                              provider.myAiList[index].imageGallery.first.url;
                        }
                        return ModelCard(
                          imageUrl: image,
                          name: provider.myAiList[index].name,
                          characterType:
                              ref
                                      .read(masterDataProvider)
                                      .characterTypes
                                      .where(
                                        (e) =>
                                            e.id ==
                                            provider
                                                .myAiList[index]
                                                .charactertypeId,
                                      )
                                      .isNotEmpty
                                  ? ref
                                      .read(masterDataProvider)
                                      .characterTypes
                                      .where(
                                        (e) =>
                                            e.id ==
                                            provider
                                                .myAiList[index]
                                                .charactertypeId,
                                      )
                                      .first
                                      .charactertypeName
                                  : null,
                          onCharTap:
                              () => ref
                                  .read(chatProvider.notifier)
                                  .setCharacter(provider.myAiList[index]),
                        );
                      },
                    ),
                    16.ph,
                  ],
                ),
              ),
    );
  }
}
