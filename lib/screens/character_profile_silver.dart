import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_profile_provider.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class CharacterProfileSilver extends ConsumerStatefulWidget {
  const CharacterProfileSilver({super.key});

  @override
  ConsumerState<CharacterProfileSilver> createState() => _CharacterProfile();
}

class _CharacterProfile extends ConsumerState<CharacterProfileSilver> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var providerAsync = ref.watch(characterProfileProvider);

    var image =
        ref
            .read(chatProvider)
            .character
            ?.imageGallery
            .firstWhere((element) => element.selected == true)
            .url;

    return Scaffold(
      backgroundColor: context.colorExt.background,

      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            expandedHeight: MediaQuery.sizeOf(context).width,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
              style: IconButton.styleFrom(
                backgroundColor: context.colorExt.background.withAlpha(100),
              ),
              onPressed: () => Navigator.of(context).pop(),
              // padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: providerAsync.when(
                error: (error, stackTrace) => Text('Error: $error'),
                loading: () => null,
                data:
                    (profile) => Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        ref.read(chatProvider).character?.name ?? "",
                        style: context.appTextStyle.appBarText,
                      ),
                    ),
              ),

              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: "character_image",
                child: Image.network(image!, fit: BoxFit.cover),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/solar_pen-2-bold.svg',
                  width: 26,
                  height: 26,
                ),
                // padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          providerAsync.when(
            error: (error, stackTrace) => Text('Error: $error'),
            loading:
                () => SliverFillRemaining(
                  child: Center(child: Lottie.asset(Assets.animations.logo)),
                ),
            data: (profile) {
              final character = profile.characterDetail;
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      const SizedBox.shrink(),
                      if (character.age.hasValue ||
                          character.gender.hasValue ||
                          character.country != null ||
                          character.city != null ||
                          character.voice != null)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 16,
                            children: [
                              // _buildAlignedRow("Name", character.name),
                              if (character.age.hasValue)
                                _buildAlignedRow("Age", character.age ?? ""),
                              if (character.gender.hasValue)
                                _buildAlignedRow(
                                  "Gender",
                                  character.gender?.capitalize() ?? "",
                                ),
                              if ((character.city?.cityName).hasValue ||
                                  (character.country?.countryName).hasValue)
                                _buildAlignedRow(
                                  "Address",
                                  "${character.city?.cityName}, ${character.country?.countryName}",
                                ),
                              if (character.voice != null)
                                _buildAlignedRow(
                                  "Voice",
                                  "${character.voice?.fullName}",
                                ),
                            ],
                          ),
                        ),
                      // 20.ph,
                      // Center(
                      //   child: LayoutBuilder(
                      //     builder: (context, constraints) {
                      //       double screenWidth = constraints.maxWidth;
                      //       return Container(
                      //         width: screenWidth * 0.98,
                      //         padding: const EdgeInsets.all(24),
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xFF23222F),
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             // buildProfileField(
                      //             //   "Sexual Orientation",
                      //             //   provider.character!.style,
                      //             // ),
                      //             // 16.ph,
                      //             buildProfileField(
                      //               "Voice",
                      //               character.voice?.fullName ?? "No voice",
                      //             ),
                      //             // 16.ph,
                      //             // buildProfileField(
                      //             //   "Language",
                      //             //   provider.character!.languageId,
                      //             // ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      if (character.characterType != null ||
                          character.relationship != null ||
                          character.personality != null ||
                          character.behaviours.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF23222F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 16,
                            children: [
                              if (character.characterType?.charactertypeName !=
                                  null)
                                buildProfileField(
                                  "What type of category fits your companion",
                                  "${character.characterType!.charactertypeName} ${character.characterType!.emoji}",
                                ),
                              if (character.relationship != null)
                                buildProfileField(
                                  "What’s your companion’s relationship to you",
                                  "${character.relationship?.title} ${character.relationship?.emoji}",
                                ),
                              if (character.personality != null)
                                buildProfileField(
                                  "What's your companion's personality type",
                                  "${character.personality?.title} ${character.personality?.emoji}",
                                ),
                              if (character.behaviours.isNotEmpty) ...[
                                buildProfileMultiField(
                                  "Which behaviour’s match your companion",
                                  character.behaviours
                                      .map((e) => "${e.title} ${e.emoji}")
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF23222F),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                          children: [
                            if (character.backStory != null)
                              buildProfileField(
                                "Back Story if any (300 words)",
                                character.backStory!,
                              ),
                            buildProfileField("Prompts", character.prompt),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.appTextStyle.textSmall.copyWith(
            color: const Color(0xFFD3D3D3),
          ),
          //  const TextStyle(
          //   color: Color(0xFFD3D3D3),
          //   fontWeight: FontWeight.w400,
          //   fontSize: 14,
          // ),
        ),
        8.ph,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF333147),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: context.appTextStyle.textSemibold),
        ),
      ],
    );
  }

  Widget buildProfileMultiField(String label, List<String> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.appTextStyle.textSmall.copyWith(
            color: const Color(0xFFD3D3D3),
          ),
        ),
        8.ph,
        Wrap(
          spacing: 10,
          children:
              values
                  .map(
                    (value) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF333147),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        value.capitalize(),
                        style: context.appTextStyle.textSemibold,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildAlignedRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: context.appTextStyle.textSmall.copyWith(
              color: const Color(0xFFD3D3D3),
            ),
          ),
        ),
        Text(
          ":",
          style: context.appTextStyle.textSmall.copyWith(
            color: const Color(0xFFD3D3D3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(value, style: context.appTextStyle.textSemibold),
        ),
      ],
    );
  }
}
