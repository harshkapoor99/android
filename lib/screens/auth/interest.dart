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

  List<String> selectedTypes = [
    "Visionaries",
    "Lover",
    "Friends",
    "Your Crush",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.h),
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
            20.ph,

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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Wrap(
                  spacing: 10.r,
                  runSpacing: 14.r,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient:
                                  isSelected
                                      ? const LinearGradient(
                                        colors: [
                                          Color(0xFFFFE031),
                                          Color(0xFFF04579),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0, 0.6],
                                      )
                                      : null,
                              color:
                                  isSelected ? null : context.colorExt.border,
                            ),
                            child: Text(
                              type.toUpperCase(),
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

            20.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GradientButton(
                title: "done",
                onTap:
                    () => context.nav.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
