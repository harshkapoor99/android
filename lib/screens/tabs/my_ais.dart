import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/model_card.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/my_ai_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
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
                      Assets.images.logoAnimation,
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You have no Character AIs of you own yet!",
                      textAlign: TextAlign.center,
                      style: context.appTextStyle.subTitle,
                    ),
                    20.ph,
                    Text(
                      "You can go to create tab to create a new Character AI for you.",
                      textAlign: TextAlign.center,
                      style: context.appTextStyle.text,
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
                          onCharTap:
                              () => ref
                                  .read(chatProvider.notifier)
                                  .setCharacter(provider.myAiList[index]),
                        );
                      },
                      // children: List.generate(imagePaths.length, (index) {
                      //   return Container(
                      //     decoration: BoxDecoration(
                      //       color: const Color(0xFF1E1E27),
                      //       borderRadius: BorderRadius.circular(12),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.black.withOpacity(0.3),
                      //           blurRadius: 6,
                      //           offset: const Offset(0, 3),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Stack(
                      //       children: [
                      //         ClipRRect(
                      //           borderRadius: BorderRadius.circular(12),
                      //           child: Image.asset(
                      //             imagePaths[index],
                      //             fit: BoxFit.cover,
                      //             width: double.infinity,
                      //             height: double.infinity,
                      //           ),
                      //         ),
                      //         Positioned(
                      //           bottom: 17,
                      //           right: 17,
                      //           child: Opacity(
                      //             opacity: 0.8, // 👈 80% opacity for button
                      //             child: GestureDetector(
                      //               onTap: () {
                      //                 debugPrint(
                      //                   "SVG Button tapped on ${imagePaths[index]}",
                      //                 );
                      //               },
                      //               child: Container(
                      //                 width: 47,
                      //                 height: 47,
                      //                 decoration: const BoxDecoration(
                      //                   shape: BoxShape.circle,
                      //                   color: Color(0xFF242424), // Deep purple
                      //                 ),
                      //                 padding: const EdgeInsets.all(13.5),
                      //                 child: SvgPicture.asset(
                      //                 import 'package:flutter/material.dart';
                      // import 'package:flutter_riverpod/flutter_riverpod.dart';
                      // import 'package:guftagu_mobile/components/model_card.dart';
                      // import 'package:guftagu_mobile/gen/assets.gen.dart';
                      // import 'package:guftagu_mobile/providers/chat_provider.dart';
                      // import 'package:guftagu_mobile/providers/my_ai_provider.dart';
                      // import 'package:guftagu_mobile/utils/context_less_nav.dart';
                      // import 'package:guftagu_mobile/utils/entensions.dart';
                      // import 'package:lottie/lottie.dart';
                      //
                      // class MyAisTab extends ConsumerStatefulWidget {
                      //   const MyAisTab({super.key});
                      //
                      //   @override
                      //   ConsumerState<MyAisTab> createState() => _MyAisTabState();
                      // }
                      //
                      // class _MyAisTabState extends ConsumerState<MyAisTab> {
                      //   @override
                      //   void initState() {
                      //     ref.read(myAiProvider.notifier).fetchMyAis();
                      //     super.initState();
                      //   }
                      //
                      //   @override
                      //   Widget build(BuildContext context) {
                      //     final provider = ref.watch(myAiProvider);
                      //     return RefreshIndicator(
                      //       onRefresh: () async {
                      //         ref.read(myAiProvider.notifier).fetchMyAis();
                      //       },
                      //       child:
                      //           provider.isLoading
                      //               ? Center(
                      //                 child: Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: [
                      //                     Lottie.asset(
                      //                       Assets.images.logoAnimation,
                      //                       width: 200,
                      //                       height: 200,
                      //                       animate: false,
                      //                     ),
                      //                     const Text(
                      //                       "Gathering your characters...",
                      //                       textAlign: TextAlign.center,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               )
                      //               : provider.myAiList.isEmpty
                      //               ? Padding(
                      //                 padding: const EdgeInsets.all(16.0),
                      //                 child: Column(
                      //                   mainAxisAlignment: MainAxisAlignment.center,
                      //                   children: [
                      //                     Text(
                      //                       "You have no Character AIs of you own yet!",
                      //                       textAlign: TextAlign.center,
                      //                       style: context.appTextStyle.subTitle,
                      //                     ),
                      //                     20.ph,
                      //                     Text(
                      //                       "You can go to create tab to create a new Character AI for you.",
                      //                       textAlign: TextAlign.center,
                      //                       style: context.appTextStyle.text,
                      //                     ),
                      //                   ],
                      //                 ),
                      //               )
                      //               : SingleChildScrollView(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 16),
                      //                 child: Column(
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //                     const SizedBox(height: 26),
                      //                     const Text(
                      //                       'My AIs',
                      //                       style: TextStyle(
                      //                         fontSize: 18,
                      //                         fontWeight: FontWeight.w600,
                      //                         color: Color(0xFFF2F2F2),
                      //                       ),
                      //                     ),
                      //                     const SizedBox(height: 18),
                      //                     GridView.builder(
                      //                       // crossAxisCount: 2,
                      //                       // shrinkWrap: true,
                      //                       // physics: const NeverScrollableScrollPhysics(),
                      //                       // mainAxisSpacing: 10,
                      //                       // crossAxisSpacing: 10,
                      //                       // childAspectRatio: 127.72 / 131,
                      //                       shrinkWrap: true,
                      //                       physics: const NeverScrollableScrollPhysics(),
                      //                       gridDelegate:
                      //                           const SliverGridDelegateWithFixedCrossAxisCount(
                      //                             crossAxisCount: 2,
                      //                             crossAxisSpacing: 12,
                      //                             mainAxisSpacing: 12,
                      //                             childAspectRatio: 0.9,
                      //                           ),
                      //                       itemCount: provider.myAiList.length,
                      //                       itemBuilder: (context, index) {
                      //                         var image =
                      //                             provider.myAiList[index].imageGallery
                      //                                 .where((element) => element.selected == true)
                      //                                 .first
                      //                                 .url;
                      //                         // ignore: unnecessary_null_comparison, prefer_conditional_assignment
                      //                         if (image == null) {
                      //                           image =
                      //                               provider.myAiList[index].imageGallery.first.url;
                      //                         }
                      //                         return ModelCard(
                      //                           imageUrl: image,
                      //                           name: provider.myAiList[index].name,
                      //                           onCharTap:
                      //                               () => ref
                      //                                   .read(chatProvider.notifier)
                      //                                   .setCharacter(provider.myAiList[index]),
                      //                         );
                      //                       },
                      //                       // children: List.generate(imagePaths.length, (index) {
                      //                       //   return Container(
                      //                       //     decoration: BoxDecoration(
                      //                       //       color: const Color(0xFF1E1E27),
                      //                       //       borderRadius: BorderRadius.circular(12),
                      //                       //       boxShadow: [
                      //                       //         BoxShadow(
                      //                       //           color: Colors.black.withOpacity(0.3),
                      //                       //           blurRadius: 6,
                      //                       //           offset: const Offset(0, 3),
                      //                       //         ),
                      //                       //       ],
                      //                       //     ),
                      //                       //     child: Stack(
                      //                       //       children: [
                      //                       //         ClipRRect(
                      //                       //           borderRadius: BorderRadius.circular(12),
                      //                       //           child: Image.asset(
                      //                       //             imagePaths[index],
                      //                       //             fit: BoxFit.cover,
                      //                       //             width: double.infinity,
                      //                       //             height: double.infinity,
                      //                       //           ),
                      //                       //         ),
                      //                       //         Positioned(
                      //                       //           bottom: 17,
                      //                       //           right: 17,
                      //                       //           child: Opacity(
                      //                       //             opacity: 0.8, // 👈 80% opacity for button
                      //                       //             child: GestureDetector(
                      //                       //               onTap: () {
                      //                       //                 debugPrint(
                      //                       //                   "SVG Button tapped on ${imagePaths[index]}",
                      //                       //                 );
                      //                       //               },
                      //                       //               child: Container(
                      //                       //                 width: 47,
                      //                       //                 height: 47,
                      //                       //                 decoration: const BoxDecoration(
                      //                       //                   shape: BoxShape.circle,
                      //                       //                   color: Color(0xFF242424), // Deep purple
                      //                       //                 ),
                      //                       //                 padding: const EdgeInsets.all(13.5),
                      //                       //                 child: SvgPicture.asset(
                      //                       //                   'assets/svgs/ic_chat.svg',
                      //                       //                 ),
                      //                       //               ),
                      //                       //             ),
                      //                       //           ),
                      //                       //         ),
                      //                       //       ],
                      //                       //     ),
                      //                       //   );
                      //                       // }),
                      //                     ),
                      //                     16.ph,
                      //                   ],
                      //                 ),
                      //               ),
                      //     );
                      //   }
                      // }  'assets/svgs/ic_chat.svg',
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }),
                    ),
                    16.ph,
                  ],
                ),
              ),
    );
  }
}
