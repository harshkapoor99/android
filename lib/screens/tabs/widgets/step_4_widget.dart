import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
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
                    Lottie.asset(Assets.images.logoAnimation),
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
                  30.ph,
                  Text(
                    '${proivider.refImageUrl.hasValue ? "Or" : ""} Choose from images',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  10.ph,

                  // 3×2 grid layout with premium tag on 2nd and 6th
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 127.72 / 131,
                    children: List.generate(proivider.characterImages.length, (
                      index,
                    ) {
                      // final isPremium = index == 1 || index == 5; // 2nd and 6th
                      return Stack(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(10.92),
                            clipBehavior: Clip.antiAlias,
                            color: const Color(0xFF272730),
                            child: Ink.image(
                              image:
                                  Image.network(
                                    proivider.characterImages[index],
                                  ).image,
                              fit: BoxFit.cover,
                              width: 127.72,
                              height: 131,
                              child: InkWell(
                                onTap: () {
                                  debugPrint(
                                    "Tapped on ${proivider.characterImages[index]}",
                                  );
                                },
                                splashColor: Colors.white24,
                                highlightColor: Colors.transparent,
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
                ],
              ),
    );
  }
}
