import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/screens/dashboard.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class CharacterSelectionScreen extends ConsumerStatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  ConsumerState<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState
    extends ConsumerState<CharacterSelectionScreen> {
  List<String> characterTypes = [
    "Scientists",
    "Fictional Characters",
    "Activists",
    "Visionaries",
    "Lover",
    "Everyday Companions",
    "Friends",
    "Athletes & Adventurers",
    "Mythical Beings",
    "Secret Admirer",
    "Artists & Creators",
    "Professionals",
    "Your Crush",
    "Fantasy Legends",
    "Spiritual Guides",
    "Philosophers",
    "Psychologists",
    "Historical Figures",
    "Environment Activist",
  ];

  List<String> selectedTypes = [];

  @override
  Widget build(BuildContext context) {
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
              "Tap on 4 - 5 of your favorite genres",
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 14,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children:
                      characterTypes.map((type) {
                        bool isSelected = selectedTypes.contains(type);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTypes.remove(type);
                              } else {
                                if (selectedTypes.length < 5) {
                                  selectedTypes.add(type);
                                }
                              }
                            });
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
                                  isSelected ? null : context.colorExt.border,
                            ),
                            child: Text(
                              type.toUpperCase(),
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

            40.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientButton(
                title: "done",
                onTap: () async {
                  await ref
                      .read(hiveServiceProvider.notifier)
                      .setSelectedInterests(value: selectedTypes);
                  context.nav.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
