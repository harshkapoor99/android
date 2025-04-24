import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/screens/tabs/home.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:lottie/lottie.dart';

class ChatTab extends ConsumerStatefulWidget {
  ChatTab({super.key});

  final List<Map<String, dynamic>> ais = [
    {"name": "Maddy", "image": Assets.images.model.modImg4},
    {"name": "Alia", "image": Assets.images.model.modImg1},
    {"name": "John", "image": Assets.images.model.modImg3},
    {"name": "Jaan", "image": Assets.images.model.modImg5},
    {"name": "Fred", "image": Assets.images.onboarding.obImg8},
    {"name": "Tisha", "image": Assets.images.model.modImg7},
    {"name": "Maddy", "image": Assets.images.onboarding.obImg6},
  ];

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
    super.initState();
  }

  void init() {
    ref.read(chatProvider.notifier).fetchChatList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatProvider);
    if (!ref.watch(isHomeVisitedProvider) &&
        provider.isFetchingChatList &&
        provider.chatList.isEmpty) {
      return Center(child: Lottie.asset(Assets.images.logoAnimation));
    }
    if (!ref.watch(isHomeVisitedProvider) && provider.chatList.isEmpty) {
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
                itemCount: widget.ais.length + 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < widget.ais.length ? 8 : 0,
                    ),
                    child: Column(
                      children: [
                        Ink(
                          height: 120,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color:
                                index == widget.ais.length
                                    ? context.colorExt.border
                                    : null,
                            image:
                                index < widget.ais.length
                                    ? DecorationImage(
                                      image:
                                          widget.ais[index]["image"].provider(),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (index == widget.ais.length) {
                                context.nav.pushNamed(Routes.explore);
                              }
                            },
                            borderRadius: BorderRadius.circular(40),
                            child:
                                index == widget.ais.length
                                    ? Center(
                                      child: SvgPicture.asset(
                                        Assets.svgs.icMyAi,
                                        height: 30,
                                        width: 30,
                                        colorFilter: ColorFilter.mode(
                                          context.colorExt.secondary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        Text(
                          index == widget.ais.length
                              ? "Explore"
                              : widget.ais[index]["name"],
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

            const CategoryList(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.read(chatProvider.notifier).fetchChatList();
                  },
                  child: ListView.builder(
                    itemCount: provider.chatList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 16,
                        ),
                        onTap: () {
                          ref
                              .read(chatProvider.notifier)
                              .setCharacter(provider.chatList[index].character);
                          Future.delayed(Durations.medium1).then((value) {
                            context.nav.pushNamed(Routes.chat);
                          });
                        },
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            backgroundImage:
                                Image.network(
                                  provider
                                      .chatList[index]
                                      .character
                                      .imageGallery
                                      .first
                                      .url,
                                ).image,
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.chatList[index].character.name,
                              style: context.appTextStyle.textSemibold.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${provider.chatList[index].lastMessageTime.hour}:${provider.chatList[index].lastMessageTime.minute}',
                              style: context.appTextStyle.textSemibold.copyWith(
                                fontSize: 12,
                                color: Color(0xFFA3A3A3)
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          provider.chatList[index].lastMessage,
                          style: context.appTextStyle.textSmall.copyWith(
                            fontSize: 12,
                              color: Color(0xFFA3A3A3)
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
