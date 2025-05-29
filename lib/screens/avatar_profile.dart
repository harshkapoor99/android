import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/character_details.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import 'package:lottie/lottie.dart';
import '../providers/chat_provider.dart'; // If .pw is here

const Color darkBackgroundColor = Color(0xFF0A0A0A);
const Color inputBackgroundColor = Color(0xFF23222F);
const Color primaryTextColor = Colors.white;
const Color secondaryTextColor = Colors.grey;
const Color iconColor = Colors.white;
const Gradient editIconGradient = LinearGradient(
  colors: [Colors.blueAccent, Colors.purpleAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Helper class for Bottom Navigation Bar items
class BottomBarIconLabel {
  BottomBarIconLabel({required this.assetName, required this.label});
  String assetName;
  String label;
}

class CharacterProfile extends ConsumerStatefulWidget {
  const CharacterProfile({super.key});

  @override
  ConsumerState<CharacterProfile> createState() => _CharacterProfile();
}

class _CharacterProfile extends ConsumerState<CharacterProfile> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(chatProvider.notifier).fetchCharacterDetails();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(chatProvider);
    var image =
        provider.character!.imageGallery
            .where((element) => element.selected == true)
            .first
            .url;

    final CharacterDetail? character = provider.characterDetail;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: primaryTextColor),
        title: Builder(
          builder: (context) {
            double horizontalPadding =
                MediaQuery.of(context).size.width * 0.175;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Text(
                "Character Profile",
                style: TextStyle(
                  color: Color(0xFFC9C9C9),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            );
          },
        ),
      ),
      body:
          provider.isFetchingCharacterDetails || character == null
              ? Center(child: Lottie.asset(Assets.animations.logo))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.ph,
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF00FFED),
                              width: 1.96,
                            ),
                            borderRadius: BorderRadius.circular(19.64),
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      20.ph,
                      Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = constraints.maxWidth;
                            return Container(
                              width: screenWidth * 0.98,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF23222F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 16,
                                children: [
                                  _buildAlignedRow("Name", character.name),
                                  if (character.age.hasValue)
                                    _buildAlignedRow(
                                      "Age",
                                      character.age ?? "",
                                    ),
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
                            );
                          },
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
                      20.ph,
                      Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = constraints.maxWidth;
                            return Container(
                              width: screenWidth * 0.98,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF23222F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (character
                                          .characterType
                                          ?.charactertypeName !=
                                      null) ...[
                                    buildProfileField(
                                      "What type of category fits your companion",
                                      "${character.characterType!.charactertypeName} ${character.characterType!.emoji}",
                                    ),
                                    16.ph,
                                  ],
                                  buildProfileField(
                                    "What’s your companion’s relationship to you",
                                    "${character.relationship?.title} ${character.relationship?.emoji}",
                                  ),
                                  16.ph,
                                  buildProfileField(
                                    "What's your companion's personality type",
                                    "${character.personality?.title} ${character.personality?.emoji}",
                                  ),
                                  if (character.behaviours.isNotEmpty) ...[
                                    16.ph,
                                    buildProfileMultiField(
                                      "Which behaviour’s match your companion",
                                      character.behaviours
                                          .map((e) => "${e.title} ${e.emoji}")
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
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
                      //             buildProfileField(
                      //               "Image description (if any)",
                      //               provider.character!.refImageDescription ??
                      //                   "N/A",
                      //             ),
                      //             16.ph,
                      //             buildProfileField(
                      //               "Back Story if any (300 words)",
                      //               provider.character!.refImageBackstory ??
                      //                   "N/A",
                      //             ),
                      //             16.ph,
                      //             buildProfileField(
                      //               "Prompts",
                      //               provider.character!.prompt,
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      40.ph,
                    ],
                  ),
                ),
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
