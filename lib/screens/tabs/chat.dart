import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      return const HomeTab();
    } else {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: ais.length + 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index < ais.length ? 8 : 0),
                    child: Column(
                      children: [
                        Ink(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
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
                          child: InkWell(
                            onTap: () {
                              if (index == ais.length) {
                                context.nav.pushNamed(Routes.explore);
                              }
                            },
                            borderRadius: BorderRadius.circular(40),
                            child:
                                index == ais.length
                                    ? Center(
                                      child: SvgPicture.asset(
                                        Assets.svgs.icMyAi,
                                        height: 25,
                                        width: 25,
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        Text(
                          index == ais.length ? "Explore" : ais[index],
                          style: context.appTextStyle.textSemibold.copyWith(
                            fontSize: 12,
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    hintText: "Search",
                    hintStyle: context.appTextStyle.textSmall.copyWith(
                      color: context.colorExt.textPrimary.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: SvgPicture.asset(
                        Assets.svgs.icSearch,
                        height: 10,
                        width: 10,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            15.ph,
            const CategoryList(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 16,
                      ),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Future.delayed(Durations.medium1).then((value) {
                          context.nav.pushNamed(Routes.chat);
                        });
                      },
                      leading: SizedBox(
                        width: 50,
                        height: 50,
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
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            chats[index]['time']!,
                            style: context.appTextStyle.textSemibold.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        chats[index]['message']!,
                        style: context.appTextStyle.textSmall.copyWith(
                          fontSize: 12,
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
