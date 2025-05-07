import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../../../components/build_selector_button.dart';
import '../../../components/choice_option_selector.dart';
import '../../../components/image_option_selector.dart';
import '../../../components/labeled_text_field.dart';
import '../../../components/multiSelector_bottom_up.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/master/master_models.dart';
import '../../../providers/master_data_provider.dart';

class Step0Widget extends ConsumerWidget {
  Step0Widget({super.key});

  final List<String> sexualOrientationOptions = ['Straight', 'Gay', 'Lesbian'];

  double _getResponsiveHorizontalPadding(
      double screenWidth, {
        double small = 16.0,
        double medium = 24.0,
        double large = 28.0,
      }) {
    if (screenWidth < 360) {
      return small;
    } else if (screenWidth < 600) {
      return medium;
    } else {
      return large;
    }
  }

// --- Helper for Responsive Vertical Spacing ---
  double _getResponsiveVerticalSpacing(
      double screenHeight, {
        double factor = 0.03,
      }) {
    return (screenHeight * factor).clamp(10.0, 40.0);
  }


  final List<Map<String, dynamic>> genderOptions = [
    {
      'label': 'Female',
      'image': 'assets/images/model/femaleNew.jpg',
      'icon': 'assets/icons/female.svg',
      'value': 'female',
    },
    {
      'label': 'Male',
      'image': 'assets/images/model/maleNew.jpg',
      'icon': 'assets/icons/male.svg',
      'value': 'male',
    },
    {
      'label': 'Others',
      'image': 'assets/images/model/lesboNew.jpg',
      'icon': 'assets/icons/lesbo.svg',
      'value': 'others',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final horizontalPadding = _getResponsiveHorizontalPadding(screenWidth);
    final verticalSpaceMedium = _getResponsiveVerticalSpacing(
      screenHeight,
      factor: 0.03,
    );
    // final verticalSpaceSmall = _getResponsiveVerticalSpacing(
    //   screenHeight,
    //   factor: 0.015,
    // );
    final containerInnerVPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 16,
      medium: 20,
      large: 24,
    );
    final containerInnerHPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 12,
      medium: 15,
      large: 18,
    );
    final maxContainerWidth = screenWidth * 0.9;

    final masterData = ref.read(masterDataProvider);
    final characterProvider = ref.watch(characterCreationProvider);

    final provider = ref.watch(characterCreationProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              labelColor: const Color(0xFFF2F2F2),
              controller: provider.characterNameController,
              label: 'Character Name',
              hintText: 'Type',
            ),
            36.ph,
            LabeledTextField(
              labelColor: const Color(0xFFF2F2F2),
              controller: provider.ageController,
              label: 'Age (yrs)',
              hintText: 'Type Eg.  26',
            ),
            36.ph,
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF2F2F2),
              ),
            ),
            12.ph,
            ImageOptionSelector(
              options: genderOptions,
              selected: provider.gender ?? "",
              onChanged:
                  (gender) => ref
                  .read(characterCreationProvider.notifier)
                  .updateWith(gender: gender),
            ),
            36.ph,
            const Text(
              'Sexual Orientation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFF2F2F2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children:
              sexualOrientationOptions.map((option) {
                final isSelected = provider.sexualOrientation == option;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () {
                      ref
                          .read(characterCreationProvider.notifier)
                          .updateWith(sexualOrientation: option);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                        isSelected
                            ? Color(0xFFBEBEBE)
                            : const Color(0xFF23222F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        option,
                        style:
                        isSelected
                            ? const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        )
                            : const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            36.ph,
            Text(
              'Companion’s  Voice',
              style: context.appTextStyle.textSemibold.copyWith(
                color: const Color(0xFFF2F2F2),
              ),
            ),
            SizedBox(height: verticalSpaceMedium),
            Center(
              child: _buildOptionTile<Voice>(
                context,
                ref,
                'Voice',
                maxContainerWidth,
                masterData.voices,
                optionToString: (v) => v.fullName,
                onSelect:
                    (p0) => ref
                    .read(characterCreationProvider.notifier)
                    .updateWith(voice: p0),
                selected: characterProvider.voice,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOptionTile<T>(
      BuildContext context,
      WidgetRef ref,
      String title,
      double width,
      List<T> options, {
        required String Function(T) optionToString,
        bool isLast = false,
        T? selected,
        required Function(T) onSelect,
      }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final responsiveBottomPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 12,
      medium: 18,
      large: 24,
    );

    final titleStyle =
        Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ) ??
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            );

    final subtitleStyle =
        Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white70) ??
            const TextStyle(color: Colors.white70, fontSize: 12);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : responsiveBottomPadding),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF23222F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(title, style: titleStyle),
          subtitle:
          selected != null
              ? Text(optionToString(selected), style: subtitleStyle)
              : null,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
          onTap: () {
            if (T == Voice) {
              _showVoiceOptionPopup(
                context,
                ref,
                title,
                options as List<Voice>,
                optionToString: optionToString as String Function(Voice),
                onSelect: onSelect as Function(Voice),
                selected: selected as Voice?,
              );
            }
            }
        ),
      ),
    );
  }

  void _showVoiceOptionPopup(
      BuildContext context,
      WidgetRef ref,
      String title,
      List<Voice> options, {
        required String Function(Voice) optionToString,
        required Function(Voice) onSelect,
        Voice? selected,
      }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final horizontalPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 16,
      medium: 24,
      large: 36,
    );
    final verticalPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 16,
      medium: 24,
      large: 36,
    );

    double responsiveRightMargin;
    if (screenWidth < 380) {
      responsiveRightMargin = 24.0;
    } else if (screenWidth < 600) {
      responsiveRightMargin = 40.0;
    } else {
      responsiveRightMargin = 64.0;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF141416),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: verticalPadding,
                    bottom: verticalPadding,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Choose from here",
                          style: TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: 10,
                      top: 5,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = selected == option;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF23222F),
                          borderRadius: BorderRadius.circular(10),
                          border:
                          isSelected
                              ? Border.all(
                            color: const Color(0xFF47C8FC),
                            width: 1,
                          )
                              : null,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              isSelected
                                  ? Assets.svgs.icPause
                                  : Assets.svgs.icPlay,
                            ),
                            12.pw,
                            Text(
                              optionToString(option),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isSelected)
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: responsiveRightMargin,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/svgs/waves.svg',
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF9D93FF),
                                        BlendMode.srcIn,
                                      ),
                                      width: 26,
                                      height: 26,
                                      semanticsLabel: 'Waves icon',
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    onSelect(option);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF16151E),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/svgs/clarity_arrow-line.svg',
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                        width: 26,
                                        height: 26,
                                        semanticsLabel: 'Arrow icon',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height:
                  MediaQuery.paddingOf(context).bottom > 0
                      ? 0
                      : verticalPadding,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
