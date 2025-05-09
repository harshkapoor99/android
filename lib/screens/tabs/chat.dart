import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/category_list.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/screens/tabs/home.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    {"name": "Explore", "image": ""},
  ];

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      init();
    }
  }

  void init() {
    ref.read(chatProvider.notifier).fetchChatList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatProvider);
    final isHomeVisited = ref.watch(isHomeVisitedProvider);
    print(isHomeVisited);
    print(provider.chatList.isEmpty);
    if (!isHomeVisited) {
      if (provider.isFetchingChatList && provider.chatList.isEmpty) {
        // Case 1: Fetching and no chats yet - show loading animation
        return Center(child: Lottie.asset(Assets.images.logoAnimation));
      } else if (provider.chatList.isEmpty) {
        // Case 2: Not fetching and no chats - show home
        return const HomeTab();
      }
    }
    return VisibilityDetector(
      key: const Key("chat-screen"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          init();
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SingleChildScrollView(
              // height: MediaQuery.sizeOf(context).height * 0.18,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                // shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                // itemCount: widget.ais.length + 1,
                // itemBuilder: (context, index) {
                children:
                    widget.ais.map((ai) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: ai["name"] == "Explore" ? 0 : 8,
                        ),
                        child: Column(
                          children: [
                            Ink(
                              height: 100,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color:
                                    ai["name"] == "Explore"
                                        ? context.colorExt.border
                                        : null,
                                image:
                                    ai["name"] != "Explore"
                                        ? DecorationImage(
                                          image: ai["image"].provider(),
                                          fit: BoxFit.cover,
                                        )
                                        : null,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (ai["name"] == "Explore") {
                                    context.nav.pushNamed(Routes.explore);
                                  }
                                },
                                borderRadius: BorderRadius.circular(40),
                                child:
                                    ai["name"] == "Explore"
                                        ? Center(
                                          child: Icon(
                                            Icons.arrow_outward_sharp,
                                            color:
                                                context.colorExt.textSecondary,
                                            size: 24,
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                            6.ph,
                            Text(
                              ai["name"],
                              style: context.appTextStyle.textBold.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
            24.ph,

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
                          vertical: 2,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: NetworkImageWithPlaceholder(
                              imageUrl:
                                  provider
                                      .chatList[index]
                                      .character
                                      .imageGallery
                                      .first
                                      .url,
                              placeholder: SvgPicture.asset(
                                Assets.svgs.icProfilePlaceholder,
                              ),
                              fit: BoxFit.cover,
                              errorWidget: SvgPicture.asset(
                                Assets.svgs.icProfilePlaceholder,
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.chatList[index].character.name,
                              style: context.appTextStyle.textSemibold.copyWith(
                                // list item title font size reduced by 2
                                fontSize: 16,
                                color: context.colorExt.textPrimary.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                            Text(
                              formatTime(
                                provider.chatList[index].lastMessageTime,
                              ),
                              style: context.appTextStyle.textSemibold.copyWith(
                                fontSize: 12,
                                color: context.colorExt.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          provider.chatList[index].lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.appTextStyle.textSmall.copyWith(
                            fontSize: 14,
                            color: context.colorExt.textSecondary,
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
      ),
    );
  }
}
