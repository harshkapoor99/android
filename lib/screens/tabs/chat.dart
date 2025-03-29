import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/screens/tabs/home.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  bool showHome = true;
  void startChat() {
    setState(() {
      showHome = false;
    });
  }

  String selectedCategoryTab = "";

  void selectCategoryTab(String tab) {
    setState(() {
      selectedCategoryTab = tab;
    });
  }

  final List<String> ais = [
    "Maddy",
    "Alia",
    "John",
    "Jaan",
    "Fred",
    "Tisha",
    "Maddy",
    "Alia",
    "John",
    "Jaan",
    "Fred",
    "Tisha",
  ];
  final List<Map<String, String>> chats = [
    {
      "name": "Jaan",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Alia",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Jaan",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Alia",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Jaan",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Alia",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Jaan",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
    {
      "name": "Alia",
      "message": "Hey jaan missing you a lot.. tell me abt your exa....",
      "time": "12:30 PM",
    },
  ];
  Widget buildCategoryTabs() {
    final categories = [
      "Lover",
      "Sports",
      "Girlfriend",
      "Bollywood",
      "Fashion",
      "Villain",
      "Comedian",
      "Anime",
      "Gamer",
      "Celebrity",
      "Sci-Fi",
      "Horror",
      "Superhero",
      "Historical",
    ];

    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected = category == selectedCategoryTab;

          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 8.0.w : 0,
            ),
            child: GestureDetector(
              onTap: () => selectCategoryTab(category),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFB1B0BD) : Color(0xFF23222F),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: context.appTextStyle.textSemibold.copyWith(
                      color:
                          isSelected
                              ? context.colorExt.background
                              : context.colorExt.textPrimary.withValues(
                                alpha: 0.6,
                              ),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showHome) {
      return HomeTab(startChat: startChat);
    } else {
      return Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 140.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: ais.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < ais.length - 1 ? 8.w : 0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 120.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(250.r),
                          image: DecorationImage(
                            image: Assets.images.img5.provider(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        ais[index],
                        style: context.appTextStyle.textSemibold.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search",
          //       // prefixIcon: Icon(Icons.search),
          //       filled: true,
          //       fillColor: Colors.grey[900],
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20.r),
          //         borderSide: BorderSide.none,
          //       ),
          //     ),
          //   ),
          // ),
          25.ph,
          buildCategoryTabs(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 16.w,
                    ),
                    onTap: () => context.nav.pushNamed(Routes.chat),
                    leading: SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: CircleAvatar(
                        backgroundImage: Assets.images.img1.provider(),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          chats[index]['name']!,
                          style: context.appTextStyle.textSemibold.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          chats[index]['time']!,
                          style: context.appTextStyle.textSemibold.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      chats[index]['message']!,
                      style: context.appTextStyle.textSmall.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }
}
