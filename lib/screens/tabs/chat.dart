import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/screens/tabs/home.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class ChatTab extends ConsumerWidget {
  ChatTab({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isHomeVisitedProvider)) {
      return HomeTab();
    } else {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: ais.length + 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < ais.length ? 8.w : 0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 120.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            color:
                                index == ais.length
                                    ? context.colorExt.border
                                    : null,
                            image:
                                index < ais.length
                                    ? DecorationImage(
                                      image:
                                          Assets.images.model.modImg4
                                              .provider(),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              index == ais.length
                                  ? Center(
                                    child: SvgPicture.asset(
                                      Assets.svgs.icMyAi,
                                      height: 20.w,
                                      width: 20.w,
                                    ),
                                  )
                                  : null,
                        ),
                        Text(
                          index == ais.length ? "Explore" : ais[index],
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
            10.ph,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 45.h,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    hintText: "Search",
                    hintStyle: context.appTextStyle.textSmall.copyWith(
                      color: context.colorExt.textPrimary.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.w,
                      ),
                      child: SvgPicture.asset(
                        Assets.svgs.icSearch,
                        height: 10.w,
                        width: 10.w,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            15.ph,
            CategoryList(),
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
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Future.delayed(Durations.medium1).then((value) {
                          context.nav.pushNamed(Routes.chat);
                        });
                      },
                      leading: SizedBox(
                        width: 50.w,
                        height: 50.w,
                        child: CircleAvatar(
                          backgroundImage:
                              Assets.images.model.modImg1.provider(),
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
        ),
      );
    }
  }
}
