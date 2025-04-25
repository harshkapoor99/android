import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/master_models.dart'; // Assuming these models exist
import 'package:guftagu_mobile/providers/character_creation_provider.dart'; // Assuming this provider exists
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart'; // Assuming this provider exists

// --- Helper for Responsive Padding/Margin ---
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

class Step2Widget extends ConsumerWidget {
  const Step2Widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final horizontalPadding = _getResponsiveHorizontalPadding(screenWidth);
    final verticalSpaceMedium = _getResponsiveVerticalSpacing(
      screenHeight,
      factor: 0.03,
    );
    final verticalSpaceSmall = _getResponsiveVerticalSpacing(
      screenHeight,
      factor: 0.015,
    );
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

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: verticalSpaceSmall),
          Text(
            'Choose Character\'s',
            style: context.appTextStyle.textSemibold.copyWith(
              color: const Color(0xFFA3A3A3),
            ),
          ),
          SizedBox(height: verticalSpaceMedium),
          Center(
            child: Container(
              width: maxContainerWidth,
              decoration: BoxDecoration(
                color: const Color(0xFF151519),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                vertical: containerInnerVPadding,
                horizontal: containerInnerHPadding,
              ),
              child: Column(
                children: [
                  _buildOptionTile<Personality>(
                    context,
                    ref,
                    'Personality',
                    'assets/icons/solar_mask-sad-linear.svg',
                    maxContainerWidth,
                    masterData.personalities,
                    optionToString: (p) => p.title,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(personality: p0),
                    selected: characterProvider.personality,
                  ),
                  _buildOptionTile<Relationship>(
                    context,
                    ref,
                    'Relationship',
                    'assets/icons/carbon_friendship.svg',
                    maxContainerWidth,
                    masterData.relationships,
                    optionToString: (r) => r.title,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(relationship: p0),
                    selected: characterProvider.relationship,
                  ),
                  _buildOptionTile<Behaviour>(
                    context,
                    ref,
                    'Behaviour',
                    'assets/icons/token_mind.svg',
                    maxContainerWidth,
                    masterData.behaviours,
                    optionToString: (b) => b.title,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(behaviour: p0),
                    selected: characterProvider.behaviour,
                  ),
                  _buildOptionTile<Voice>(
                    context,
                    ref,
                    'Voice',
                    'assets/icons/ri_voice-ai-fill.svg',
                    maxContainerWidth,
                    masterData.voices,
                    optionToString: (v) => v.fullName,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(voice: p0),
                    selected: characterProvider.voice,
                  ),
                  _buildOptionTile<Country>(
                    context,
                    ref,
                    'Country',
                    'assets/icons/ci_flag.svg',
                    maxContainerWidth,
                    masterData.countries,
                    optionToString: (c) => c.countryName,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(country: p0),
                    selected: characterProvider.country,
                  ),
                  _buildOptionTile<City>(
                    context,
                    ref,
                    'City',
                    'assets/icons/mage_location.svg',
                    maxContainerWidth,
                    masterData.cities,
                    optionToString: (c) => c.cityName,
                    onSelect:
                        (p0) => ref
                            .read(characterCreationProvider.notifier)
                            .updateWith(city: p0),
                    selected: characterProvider.city,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: verticalSpaceMedium),
        ],
      ),
    );
  }

  Widget _buildOptionTile<T>(
    BuildContext context,
    WidgetRef ref,
    String title,
    String icon,
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
          leading: SvgPicture.asset(icon, width: 24, height: 24),
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
            } else {
              _showOptionPopup<T>(
                context,
                ref,
                title,
                options,
                optionToString: optionToString,
                onSelect: onSelect,
              );
            }
          },
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
                                    color: const Color(0xFF5C67FF),
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

  // --- Generic Option Popup (Responsive Grid) ---

  void _showOptionPopup<T>(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<T> options, {
    required String Function(T) optionToString,
    required Function(T) onSelect,
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

    final crossAxisCount =
        screenWidth < 360
            ? 2
            : screenWidth < 600
            ? 3
            : 4;

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
                      Expanded(
                        child: Text(
                          "Choose a $title $screenWidth",
                          style: const TextStyle(
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: 10,
                      top: 5,
                    ),
                    child:
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //   //   crossAxisCount: crossAxisCount,
                    //   //   crossAxisSpacing: 12,
                    //   //   mainAxisSpacing: 12,
                    //   //   childAspectRatio: 2.5,
                    //   // ),
                    //   itemCount: options.length,
                    //   itemBuilder: (context, index) {
                    Wrap(
                      // spacing: 10,
                      // runSpacing: 14,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children:
                          options.map((option) {
                            // final option = options[index];
                            return GestureDetector(
                              onTap: () {
                                onSelect(option);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF23222F),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    optionToString(option),
                                    // textAlign: TextAlign.center,
                                    // overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFFE5E5E5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
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
