import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_type_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class CharacterSelectionScreen extends ConsumerWidget {
  const CharacterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserInterestState> providerAsync = ref.watch(
      userInterestProvider,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.ph,
            Text(
              "Select your preferred\ncharacter types",
              textAlign: TextAlign.center,
              style: AppTextStyle(
                context,
              ).appBarText.copyWith(fontWeight: FontWeight.bold),
            ),
            10.ph,
            Text(
              "Tap on 4 - 5 of your favorite categories",
              style: AppTextStyle(context).textSmall.copyWith(fontSize: 12),
            ),
            50.ph,

            // Expanded(
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: characterTypes.length,
            //     itemBuilder: (context, index) {
            //       bool isSelected = selectedTypes.contains(
            //         characterTypes[index],
            //       );
            //       return Row(
            //         children: [
            //           GestureDetector(
            //             onTap: () {
            //               setState(() {
            //                 if (isSelected) {
            //                   selectedTypes.remove(characterTypes[index]);
            //                 } else {
            //                   if (selectedTypes.length < 5) {
            //                     selectedTypes.add(characterTypes[index]);
            //                   }
            //                 }
            //               });
            //             },
            //             child: Container(
            //               padding: const EdgeInsets.symmetric(
            //                 horizontal: 16,
            //                 vertical: 10,
            //               ),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(20),
            //                 gradient:
            //                     isSelected
            //                         ? const LinearGradient(
            //                           colors: [Colors.yellow, Colors.pink],
            //                         )
            //                         : null,
            //                 color: isSelected ? null : Colors.grey[900],
            //               ),
            //               child: Text(
            //                 characterTypes[index],
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            providerAsync.when(
              loading:
                  () => Expanded(
                    child: Center(
                      child: Lottie.asset(
                        Assets.animations.logo,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
              error: (error, stackTrace) => Text(error.toString()),
              data:
                  (data) => Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 14,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children:
                            data.characterTypes.map((type) {
                              bool isSelected = data.selectedCharacterTypes
                                  .contains(type);
                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .read(userInterestProvider.notifier)
                                      .toggleCharacterType(type);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient:
                                        isSelected
                                            ? const LinearGradient(
                                              colors: [
                                                Color(0xFFFC5159),
                                                Color(0xFFF237EF),
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                              stops: [0, 0.6],
                                            )
                                            : null,
                                    color:
                                        isSelected
                                            ? null
                                            : context.colorExt.border,
                                  ),
                                  child: Text(
                                    type.charactertypeName.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
            ),

            40.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientButton(
                title: "done",
                disabled: ref.watch(userInterestButtonStatusProvider),
                showLoading: ref
                    .watch(userInterestProvider)
                    .maybeWhen(
                      data: (data) => data.isLoading,
                      orElse: () => false,
                    ),
                onTap: () async {
                  var res =
                      await ref
                          .read(userInterestProvider.notifier)
                          .saveInterests();
                  if (res.isSuccess) {
                    context.nav.pushNamedAndRemoveUntil(
                      Routes.dashboard,
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    AppConstants.showSnackbar(
                      message: res.message,
                      isSuccess: res.isSuccess,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
