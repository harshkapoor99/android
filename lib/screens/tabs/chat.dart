import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/screens/tabs/home.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class ChatTab extends ConsumerStatefulWidget {
  const ChatTab({super.key});

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchChats();
    });
    super.initState();
  }

  void fetchChats() {
    ref.read(chatProvider.notifier).fetchChatList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatProvider);

    if (provider.chatList.isEmpty) {
      if (provider.isFetchingChatList) {
        // Case 1: Fetching and no chats yet - show loading animation
        return Center(child: Lottie.asset(Assets.animations.logo));
      } else {
        // Case 2: Not fetching and no chats - show home
        return const HomeTab();
      }
    }
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SingleChildScrollView(
              // height: MediaQuery.sizeOf(context).height * 0.18,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: HeaderCharacterRow(),
            ),
            16.ph,
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Divider(),
            // ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("Chats", style: context.appTextStyle.textSemibold),
              ),
            ),
            Expanded(
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
                              // list item title font size reduced
                              fontSize: 15,
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
                              color: context.colorExt.textHint,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        provider.chatList[index].lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.appTextStyle.textSmall.copyWith(
                          // list item text font size reduced
                          fontSize: 12,
                          color: context.colorExt.textHint,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCharacterRow extends ConsumerWidget {
  const HeaderCharacterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterCharacters = ref.watch(
      masterDataProvider.select((value) => value.characters),
    );
    List<Character> characters = List<Character>.from(masterCharacters);
    characters.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...characters
            .sublist(0, characters.length <= 10 ? characters.length : 10)
            .map((ai) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    Ink(
                      height: 100,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: null,
                        image: DecorationImage(
                          image: Image.network(ai.imageGallery[0].url).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          ref.read(chatProvider.notifier).setCharacter(ai);
                          context.nav.pushNamed(Routes.chat);
                        },
                        borderRadius: BorderRadius.circular(40),
                        child: null,
                      ),
                    ),
                    6.ph,
                    SizedBox(
                      width: 80,
                      child: Text(
                        ai.name,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: context.appTextStyle.textBold.copyWith(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
        Column(
          children: [
            Ink(
              height: 100,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: context.colorExt.border,
              ),
              child: InkWell(
                onTap: () {
                  ref.read(masterDataProvider.notifier).fetchMasterCharacters();
                  context.nav.pushNamed(Routes.explore);
                },
                borderRadius: BorderRadius.circular(40),
                child: Center(
                  child: Icon(
                    Icons.arrow_outward_sharp,
                    color: context.colorExt.textHint,
                    size: 24,
                  ),
                ),
              ),
            ),
            6.ph,
            Text(
              "Explore",
              style: context.appTextStyle.textBold.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
