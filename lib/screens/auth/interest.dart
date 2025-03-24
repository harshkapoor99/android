import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/screens/dashboard.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final List<String> characterTypes = [
    "BOLLYWOOD",
    "FASHION",
    "HOT",
    "TYPE 3",
    "LOVER",
    "HAPPY",
    "ROMANTIC",
    "ACTION HERO",
    "COMEDY KING/QUEEN",
    "MYSTERIOUS",
    "TRENDSETTER",
    "ADVENTURER",
    "DARK & BROODY",
    "MUSIC LOVER",
    "SCI-FI ENTHUSIAST",
    "FANTASY FANATIC",
    "DRAMA QUEEN",
    "SUPERNATURAL",
    "HISTORICAL",
    "THRILL SEEKER",
  ];

  List<String> selectedTypes = ["MYSTERIOUS", "LOVER", "DARK & BROODY"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              style: AppTextStyle(context).textSmall.copyWith(fontSize: 12.sp),
            ),
            50.ph,
            // Expanded(
            //   child: ListView.builder(
            //     itemBuilder: (context, index) {
            //       bool isSelected = selectedTypes.contains(
            //         characterTypes[index],
            //       );
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             if (isSelected) {
            //               selectedTypes.remove(characterTypes[index]);
            //             } else {
            //               if (selectedTypes.length < 5) {
            //                 selectedTypes.add(characterTypes[index]);
            //               }
            //             }
            //           });
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 16,
            //             vertical: 10,
            //           ),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             gradient:
            //                 isSelected
            //                     ? const LinearGradient(
            //                       colors: [Colors.yellow, Colors.pink],
            //                     )
            //                     : null,
            //             color: isSelected ? null : Colors.grey[900],
            //           ),
            //           child: Text(
            //             characterTypes[index],
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //     shrinkWrap: true,
            //     itemCount: characterTypes.length,
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
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
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient:
                                  isSelected
                                      ? const LinearGradient(
                                        colors: [Colors.yellow, Colors.pink],
                                      )
                                      : null,
                              color: isSelected ? null : Colors.grey[900],
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
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
            50.ph,
            GradientButton(
              title: "done",
              onTap:
                  () => context.nav.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                    (Route<dynamic> route) => false,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
