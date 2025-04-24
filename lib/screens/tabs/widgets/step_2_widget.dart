import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';

import 'package:guftagu_mobile/models/master/master_models.dart'; // Assuming these models exist

import 'package:guftagu_mobile/providers/character_creation_provider.dart'; // Assuming this provider exists

import 'package:guftagu_mobile/providers/master_data_provider.dart'; // Assuming this provider exists

// import 'package:guftagu_mobile/utils/context_less_nav.dart'; // If needed

// import 'package:guftagu_mobile/utils/entensions.dart'; // Remove if .ph extension is no longer used

// --- Helper for Responsive Padding/Margin ---

// Adjust breakpoints and values based on your design needs

double _getResponsiveHorizontalPadding(
  double screenWidth, {
  double small = 16.0,
  double medium = 24.0,
  double large = 28.0,
}) {
  if (screenWidth < 400) {
    // Example breakpoint for small devices

    return small;
  } else if (screenWidth < 800) {
    // Example breakpoint for medium devices

    return medium;
  } else {
    // Large devices

    return large;
  }
}

// --- Helper for Responsive Vertical Spacing ---

// Adjust factor based on design needs

double _getResponsiveVerticalSpacing(
  double screenHeight, {
  double factor = 0.03,
}) {
  // Ensure factor is reasonable, perhaps clamp it

  return (screenHeight * factor).clamp(
    10.0,
    40.0,
  ); // Example clamp: min 10, max 40
}

class Step2Widget extends ConsumerWidget {
  const Step2Widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final screenHeight = MediaQuery.sizeOf(context).height;

    // Calculate responsive values

    final horizontalPadding = _getResponsiveHorizontalPadding(screenWidth);

    final verticalSpaceMedium = _getResponsiveVerticalSpacing(
      screenHeight,
      factor: 0.03,
    ); // ~3% of height

    final verticalSpaceSmall = _getResponsiveVerticalSpacing(
      screenHeight,
      factor: 0.015,
    ); // ~1.5% of height

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

    // Max width for the inner container remains responsive

    final maxContainerWidth = screenWidth * 0.9;

    // Read providers

    // Using read inside build is generally discouraged for data that changes.

    // If masterData can change, consider using ref.watch.

    final masterData = ref.read(masterDataProvider);

    final characterProvider = ref.watch(
      characterCreationProvider,
    ); // Watch for state changes

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(height: verticalSpaceSmall), // Responsive top spacing

          Text(
            'Choose Character\'s',

            // Use Theme for text styles if possible for consistency
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,

                  color: const Color(0xFFF2F2F2),
                ) ??
                const TextStyle(
                  // Fallback style
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF2F2F2),
                ),
          ),

          SizedBox(height: verticalSpaceMedium), // Responsive spacing

          Center(
            child: Container(
              width: maxContainerWidth, // Responsive width

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
                  // Pass ref to the builder function
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

                    isLast: true, // Mark the last one
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: verticalSpaceMedium), // Responsive bottom spacing
        ],
      ),
    );
  }

  // --- Builder function for each option tile ---

  Widget _buildOptionTile<T>(
    BuildContext context,

    WidgetRef ref, // Accept ref

    String title,

    String icon,

    double
    width, // This might not be strictly needed if ListTile fills container

    List<T> options, {

    required String Function(T) optionToString,

    bool isLast = false,

    T? selected,

    required Function(T) onSelect,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Responsive bottom padding between tiles

    final responsiveBottomPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 12,
      medium: 18,
      large: 24,
    );

    // Use Theme text styles when possible

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
          // Leading icon - NO unintended color change
          leading: SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ), // Default SVG colors

          title: Text(title, style: titleStyle),

          subtitle:
              selected != null
                  ? Text(optionToString(selected), style: subtitleStyle)
                  : null,

          // Trailing icon - Color as originally specified
          trailing: const Icon(
            Icons.arrow_forward_ios,

            color: Colors.white,

            size: 16, // Kept fixed, make responsive if needed
          ),

          onTap: () {
            // Determine which popup to show based on type T

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

          // Consider adding visual density for tighter spacing on small screens

          // visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }

  // --- Voice Selection Popup (Responsive) ---

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

    // Responsive padding/spacing

    final horizontalPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 16,
      medium: 24,
      large: 33,
    );

    final verticalPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 12,
      medium: 16,
      large: 21,
    ); // Use horizontal helper for consistency or create separate vertical

    // --- Responsive margin logic for the trailing widget ---

    double responsiveRightMargin;

    // Adjust breakpoints and margin values as needed

    if (screenWidth < 380) {
      responsiveRightMargin = 24.0;
    } else if (screenWidth < 600) {
      responsiveRightMargin = 40.0;
    } else if (screenWidth < 960) {
      responsiveRightMargin = 64.0;
    } else {
      responsiveRightMargin = 64.0;
    } // Capped margin

    // --- End responsive margin logic ---

    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent, // Make container background visible

      isScrollControlled: true, // Allows sheet to be taller than half screen

      builder: (context) {
        // Limit the max height and allow it to shrink to content

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.8, // Max 80% of screen height
          ),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF141416), // Bottom sheet background

              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit content height vertically

              children: [
                // --- Header ---
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,

                    right: horizontalPadding,

                    top: verticalPadding,

                    bottom: verticalPadding / 2, // Less padding below header
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Choose from here",
                          style: const TextStyle(
                            color: Color(0xFFF2F2F2),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // --- Scrollable List ---
                Flexible(
                  // Allows ListView to take available space and scroll
                  child: ListView.builder(
                    shrinkWrap: true, // Needed when inside Flexible/Column

                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: 10,
                      top: 5,
                    ), // Add padding for list

                    itemCount: options.length,

                    itemBuilder: (context, index) {
                      final option = options[index];

                      final isSelected = selected == option;

                      return Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ), // Spacing between items

                        decoration: BoxDecoration(
                          color: const Color(0xFF23222F), // Item background

                          borderRadius: BorderRadius.circular(10),

                          border:
                              isSelected
                                  ? Border.all(
                                    color: const Color(0xFF5C67FF),
                                    width: 1,
                                  )
                                  : null,
                        ),

                        child: ListTile(
                          // Leading Play/Pause Icon (kept fixed size)
                          leading: Container(
                            width: 40,
                            height: 40,

                            decoration: const BoxDecoration(
                              color: Color(0xFFA099FF),
                              shape: BoxShape.circle,
                            ),

                            child: Center(
                              child: Icon(
                                isSelected ? Icons.pause : Icons.play_arrow,
                                color: Color(0xFF16151E),
                              ),
                            ),
                          ),

                          title: Text(
                            optionToString(option),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // --- Responsive Trailing Widget ---
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              // Conditional Waves icon
                              if (isSelected)
                                Container(
                                  margin: EdgeInsets.only(
                                    right: responsiveRightMargin,
                                  ), // Apply responsive margin

                                  child: SvgPicture.asset(
                                    'assets/svgs/waves.svg', // Verify path

                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF9D93FF),
                                      BlendMode.srcIn,
                                    ), // Original color

                                    width: 26,
                                    height: 26, // Kept fixed size

                                    semanticsLabel: 'Waves icon',
                                  ),
                                ),

                              // Arrow container (kept fixed size)
                              Container(
                                width: 40,
                                height: 40,

                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),

                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/svgs/clarity_arrow-line.svg', // Verify path

                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ), // Original color

                                    width: 20,
                                    height: 20, // Kept fixed size

                                    semanticsLabel: 'Arrow icon',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // --- End Responsive Trailing ---
                          onTap: () {
                            onSelect(option);

                            Navigator.pop(context); // Close sheet on selection
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Add padding at the very bottom if needed
                SizedBox(
                  height:
                      MediaQuery.paddingOf(context).bottom > 0
                          ? 0
                          : verticalPadding,
                ), // Add bottom padding only if no system bottom inset (like notch area)
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

    // Responsive padding

    final horizontalPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 16,
      medium: 24,
      large: 33,
    );

    final verticalPadding = _getResponsiveHorizontalPadding(
      screenWidth,
      small: 12,
      medium: 16,
      large: 21,
    );

    // Responsive crossAxisCount logic (already present)

    final crossAxisCount =
        screenWidth < 400
            ? 2
            : screenWidth < 700
            ? 3
            : 4;

    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      isScrollControlled: true, // Allow flexible height

      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.8, // Max height
          ),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF141416),

              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit content

              children: [
                // --- Header ---
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,

                    right: horizontalPadding,

                    top: verticalPadding,

                    bottom: verticalPadding / 2,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Choose a $title",
                          style: const TextStyle(
                            color: Color(0xFFF2F2F2),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // --- Scrollable Grid ---
                Flexible(
                  child: Padding(
                    // Use horizontal padding for the grid area
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: 10,
                      top: 5,
                    ),

                    child: GridView.builder(
                      shrinkWrap: true,

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount, // Responsive count

                        crossAxisSpacing: 12, // Fixed spacing

                        mainAxisSpacing: 12, // Fixed spacing

                        childAspectRatio:
                            2.5, // Fixed aspect ratio - TEST THIS across sizes
                      ),

                      itemCount: options.length,

                      itemBuilder: (context, index) {
                        final option = options[index];

                        return GestureDetector(
                          onTap: () {
                            onSelect(option);
                            Navigator.pop(context);
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ), // Adjusted horizontal padding slightly

                            decoration: BoxDecoration(
                              color: const Color(0xFF23222F),
                              borderRadius: BorderRadius.circular(100),
                            ), // Pill shape

                            child: Center(
                              child: Text(
                                optionToString(option),

                                textAlign: TextAlign.center,

                                overflow:
                                    TextOverflow
                                        .ellipsis, // Handle potential overflow

                                style: const TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height:
                      MediaQuery.paddingOf(context).bottom > 0
                          ? 0
                          : verticalPadding,
                ), // Bottom padding
              ],
            ),
          ),
        );
      },
    );
  }
}
