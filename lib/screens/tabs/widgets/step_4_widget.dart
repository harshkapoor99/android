import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class Step4Widget extends ConsumerWidget {
  const Step4Widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proivider = ref.watch(characterCreationProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child:
          proivider.isCharacterGenerating
              ? Center(
                child: Column(
                  children: [
                    Lottie.asset(Assets.animations.logo),
                    const Text(
                      "Generating Character...",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (proivider.refImageUrl.hasValue)
                    Center(
                      child: Column(
                        children: [
                          // Character image container
                          Container(
                            width: 167,
                            height: 167,
                            decoration: BoxDecoration(
                              color: const Color(0xFF272730),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                proivider.refImageUrl!,
                                fit: BoxFit.cover,
                                alignment: const Alignment(
                                  0,
                                  -0.5,
                                ), // move image slightly up
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 83.25,
                                      color: Color(0xFF5B5B69),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          10.ph,
                          const Text(
                            'Here is your Chat Partner',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  26.ph,
                  Text(
                    // '${proivider.refImageUrl.hasValue ? "Or" : ""} Choose from images',
                    'Choose from images',
                    style: context.appTextStyle.text.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFA3A3A3),
                    ),
                  ),
                  16.ph,

                  // 3×2 grid layout with premium tag on 2nd and 6th
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                    children: List.generate(proivider.characterImages.length, (
                      index,
                    ) {
                      // final isPremium = index == 1 || index == 5; // 2nd and 6th
                      final isSeleted =
                          proivider.seletedCharacterImage?.id ==
                          proivider.characterImages[index].id;
                      return Stack(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            clipBehavior: Clip.antiAlias,
                            color: const Color(0xFF272730),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2, // You can adjust this
                                  color:
                                      isSeleted
                                          ? context.colorExt.tertiary
                                          : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Ensure it matches the Material
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image:
                                          Image.network(
                                            proivider
                                                .characterImages[index]
                                                .url,
                                          ).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(
                                            characterCreationProvider.notifier,
                                          )
                                          .updateWith(
                                            seletedCharacterImage:
                                                proivider
                                                    .characterImages[index],
                                          );
                                    },
                                    splashColor: Colors.white24,
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // if (isPremium)
                          //   Positioned(
                          //     top: 6,
                          //     right: 6,
                          //     child: SvgPicture.asset(
                          //       'assets/svgs/premium.svg',
                          //       width: 24,
                          //       height: 24,
                          //     ),
                          //   ),
                        ],
                      );
                    }),
                  ),
                  20.ph,
                ],
              ),
    );
  }
}
