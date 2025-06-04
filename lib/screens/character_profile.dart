import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_profile_provider.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class CharacterProfile extends ConsumerStatefulWidget {
  const CharacterProfile({super.key});

  @override
  ConsumerState<CharacterProfile> createState() => _CharacterProfile();
}

class _CharacterProfile extends ConsumerState<CharacterProfile> {
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
    final AsyncValue<CharacterProfileState> providerAsync = ref.watch(
      characterProfileProvider,
    );

    final FocusNode descriptionFocusNode = FocusNode();

    var image =
        ref
            .read(chatProvider)
            .character
            ?.imageGallery
            .firstWhere((element) => element.selected == true)
            .url;

    return Scaffold(
      backgroundColor: context.colorExt.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          style: IconButton.styleFrom(
            backgroundColor: context.colorExt.background.withAlpha(100),
          ),
          onPressed: () => Navigator.of(context).pop(),
          // padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        actions: [
          if (ref.read(chatProvider).character?.creatorUserType.toLowerCase() ==
              "user")
            IconButton(
              onPressed: () {
                ref.read(characterProfileProvider.notifier).toggleEditMode();
              },
              icon: SvgPicture.asset(
                'assets/icons/solar_pen-2-bold.svg',
                width: 26,
                height: 26,
              ),
              // padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
        centerTitle: true,
        title: providerAsync.when(
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => null,
          data:
              (profile) => Text(
                profile.characterDetail.name,
                style: context.appTextStyle.appBarText,
              ),
        ),
      ),
      body: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                10.ph,
                Stack(
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Hero(
                        tag: "character_image",
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19.64),
                            image: DecorationImage(
                              image: NetworkImage(image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                20.ph,
                providerAsync.when(
                  error: (error, stackTrace) => Text('Error: $error'),
                  loading:
                      () => Center(child: Lottie.asset(Assets.animations.logo)),
                  data: (profile) {
                    final character = profile.characterDetail;
                    return Column(
                      children: [
                        Column(
                          children: [
                            if (profile.genImages.isNotEmpty)
                              AnimatedSize(
                                duration: Durations.medium1,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: const Color(0xFF272730),
                                  ),
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1,
                                    children: List.generate(profile.genImages.length, (
                                      index,
                                    ) {
                                      // final isPremium = index == 1 || index == 5; // 2nd and 6th
                                      final isSeleted =
                                          profile.seletedCharacterImage?.id ==
                                          profile.genImages[index].id;
                                      return Stack(
                                        children: [
                                          Material(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            color: const Color(0xFF272730),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width:
                                                      2, // You can adjust this
                                                  color:
                                                      isSeleted
                                                          ? context
                                                              .colorExt
                                                              .tertiary
                                                          : Colors.transparent,
                                                ),
                                                borderRadius: BorderRadius.circular(
                                                  10,
                                                ), // Ensure it matches the Material
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    image: DecorationImage(
                                                      image:
                                                          Image.network(
                                                            profile
                                                                .genImages[index]
                                                                .url,
                                                          ).image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  width: 200,
                                                  height: 200,
                                                  child: InkWell(
                                                    onTap: () {
                                                      ref
                                                          .read(
                                                            characterProfileProvider
                                                                .notifier,
                                                          )
                                                          .selectImage(
                                                            profile
                                                                .genImages[index],
                                                          );
                                                    },
                                                    splashColor: Colors.white24,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // if (isPremium)
                                          //   Positioned(
                                          //     top: 6,
                                          //     right: 6,
                                          //     child: SvgPicture.asset(
                                          //       'assets/svgs/premium.svg',
                                          //       width: 24,
                                          //       height: 24,
                                          //     ),
                                          //   ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            AnimatedContainer(
                              height: profile.editMode ? 200 : 0,
                              duration: Durations.medium1,
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFF272730),
                              ),

                              child: Stack(
                                children: [
                                  TextField(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    controller: profile.descriptionController,
                                    focusNode: descriptionFocusNode,
                                    style: context.appTextStyle.text,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    maxLines: null,
                                    minLines: null,
                                    expands: true,
                                    decoration: InputDecoration(
                                      hintStyle: context.appTextStyle.hintText
                                          .copyWith(
                                            fontSize: 16,
                                            overflow: TextOverflow.fade,
                                          ),
                                      // hintText:
                                      //     profile.editMode
                                      //         ? "Eg. A confident South Indian woman in her late 20s, wearing a mustard saree, standing in a sunlit street in Kochi. Curly hair, brown eyes, soft smile, golden hour lighting."
                                      //         : null,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // contentPadding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 16,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child:
                                          descriptionFocusNode.hasFocus ||
                                                  profile
                                                      .descriptionController
                                                      .text
                                                      .isNotEmpty
                                              ? null
                                              : SizedBox(
                                                height: 32,
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                          characterProfileProvider
                                                              .notifier,
                                                        )
                                                        .generateRandomPrompt();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF1C1B2A),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  icon: ShaderMask(
                                                    shaderCallback:
                                                        (
                                                          bounds,
                                                        ) => const LinearGradient(
                                                          colors: [
                                                            Color(0xFFAD00FF),
                                                            Color(0xFF00E0FF),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                        ).createShader(bounds),
                                                    child: SvgPicture.asset(
                                                      'assets/svgs/ic_chat_prefix.svg',
                                                      width: 18,
                                                      height: 18,
                                                      colorFilter:
                                                          const ColorFilter.mode(
                                                            Colors.white,
                                                            BlendMode.srcIn,
                                                          ),
                                                    ),
                                                  ),
                                                  label: const Text(
                                                    'Random Prompt',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFE5E5E5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child:
                                          descriptionFocusNode.hasFocus ||
                                                  profile
                                                      .descriptionController
                                                      .text
                                                      .isNotEmpty
                                              ? null
                                              : SvgPicture.asset(
                                                'assets/icons/mingcute_quill-pen-line.svg',
                                                width: 18,
                                                height: 18,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              height: profile.editMode ? 50 : 0,
                              duration: Durations.medium4,
                              child: GradientButton(
                                title:
                                    profile.genImages.isEmpty
                                        ? "Create Images"
                                        : "Save Image",
                                showLoading: profile.isGeneratingImages,
                                onTap:
                                    profile.genImages.isEmpty
                                        ? ref
                                            .read(
                                              characterProfileProvider.notifier,
                                            )
                                            .generateNewImages
                                        : ref
                                            .read(
                                              characterProfileProvider.notifier,
                                            )
                                            .updateImage,
                              ),
                            ),
                          ],
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
                                        (character.country?.countryName)
                                            .hasValue)
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
                        //             //   profile.character!.style,
                        //             // ),
                        //             // 16.ph,
                        //             buildProfileField(
                        //               "Voice",
                        //               character.voice?.fullName ?? "No voice",
                        //             ),
                        //             // 16.ph,
                        //             // buildProfileField(
                        //             //   "Language",
                        //             //   profile.character!.languageId,
                        //             // ),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        20.ph,
                        if (character.characterType != null ||
                            character.relationship != null ||
                            character.personality != null ||
                            character.behaviours.isNotEmpty)
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      if (character.relationship != null) ...[
                                        buildProfileField(
                                          "What’s your companion’s relationship to you",
                                          "${character.relationship?.title} ${character.relationship?.emoji}",
                                        ),
                                        16.ph,
                                      ],
                                      if (character.personality != null)
                                        buildProfileField(
                                          "What's your companion's personality type",
                                          "${character.personality?.title} ${character.personality?.emoji}",
                                        ),
                                      if (character.behaviours.isNotEmpty) ...[
                                        16.ph,
                                        buildProfileMultiField(
                                          "Which behaviour’s match your companion",
                                          character.behaviours
                                              .map(
                                                (e) => "${e.title} ${e.emoji}",
                                              )
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
                        //               profile.character!.refImageDescription ??
                        //                   "N/A",
                        //             ),
                        //             16.ph,
                        //             buildProfileField(
                        //               "Back Story if any (300 words)",
                        //               profile.character!.refImageBackstory ??
                        //                   "N/A",
                        //             ),
                        //             16.ph,
                        //             buildProfileField(
                        //               "Prompts",
                        //               profile.character!.prompt,
                        //             ),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        40.ph,
                      ],
                    );
                  },
                ),
              ],
            ),
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
