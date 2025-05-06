import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart'; // Assuming this exists for popup icons
import 'package:guftagu_mobile/models/master/master_models.dart'; // Assuming these models exist (including Category)
import 'package:guftagu_mobile/providers/character_creation_provider.dart'; // Assuming this provider exists
import 'package:guftagu_mobile/providers/master_data_provider.dart';
// import 'package:guftagu_mobile/utils/context_less_nav.dart'; // Not used directly in this snippet
import 'package:guftagu_mobile/utils/entensions.dart'; // Keep for .pw extension used in popups

// --- Removed Responsive Helpers for Simplicity (Add back if needed) ---
// You can add the _getResponsive... functions back if you prefer them over fixed values

class Step2Widget extends ConsumerWidget {
  const Step2Widget({super.key});

  // --- UI Constants based on image_cd8fa4.png ---
  static const double _horizontalPadding = 24.0;
  static const double _verticalItemSpacing = 28.0; // Space between each selection item
  static const double _titleBottomSpacing = 12.0; // Space between title and selector bar
  static const Color _titleColor = Color(0xFFE5E5E5); // Light grey/white for titles
  static const Color _selectorBgColor = Color(0xFF3A2F4B); // Purple-ish selector box
  static const Color _selectorIconColor = Color(0xFF47C8FC); // Cyan icon color
  static const Color _selectorTextColor = Color(0xFFE5E5E5); // Light text in selector
  static const Color _selectPlaceholderColor = Color(0xFFA3A3A3); // Grey for "Select" placeholder
  static const Color _chevronColor = Color(0xFFA3A3A3); // Grey for chevron
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterData = ref.read(masterDataProvider); // Read once for options list
    final characterProvider = ref.watch(characterCreationProvider); // Watch for selected values

    // TODO: Ensure masterData has 'categories' and CharacterCreationState supports 'category'
    // final List<Category> categoryOptions = masterData.categories ?? [];
    // final Category? selectedCategory = characterProvider.category;

    // Using dummy data for category as it's not in the original code
    // Replace with actual data fetching and provider state
    final List<String> categoryOptions = ["Friend", "Mentor", "Assistant", "Fictional"];
    final String? selectedCategory = null; // Placeholder

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 20.0, // Add some vertical padding for the scroll view
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Category ---
          _buildSelectionItem<String>( // Use <Category> if you have the model
            context: context,
            ref: ref,
            title: 'What type of category fits your companion',
            iconPath: 'assets/icons/category_icon.svg', // ** UPDATE ICON PATH **
            options: categoryOptions, // Replace with masterData.categories
            selected: selectedCategory, // Replace with characterProvider.category
            optionToString: (cat) => cat, // Adjust if using Category model (e.g., cat.title)
            onSelect: (cat) {
              print("Selected Category: $cat");
              // TODO: Update provider: ref.read(characterCreationProvider.notifier).updateWith(category: cat);
            },
          ),
          const SizedBox(height: _verticalItemSpacing),

          // --- Relationship ---
          _buildSelectionItem<Relationship>(
            context: context,
            ref: ref,
            title: 'What\'s your companion\'s relationship to you',
            iconPath: 'assets/icons/relationship_icon.svg', // ** UPDATE ICON PATH (e.g., carbon_friendship.svg?)**
            options: masterData.relationships,
            selected: characterProvider.relationship,
            optionToString: (r) => r.title,
            onSelect: (rel) => ref
                .read(characterCreationProvider.notifier)
                .updateWith(relationship: rel),
          ),
          const SizedBox(height: _verticalItemSpacing),

          // --- Personality ---
          _buildSelectionItem<Personality>(
            context: context,
            ref: ref,
            title: 'What\'s your companion\'s personality type',
            iconPath: 'assets/icons/personality_icon.svg', // ** UPDATE ICON PATH (e.g., solar_mask-sad-linear.svg?) **
            options: masterData.personalities,
            selected: characterProvider.personality,
            optionToString: (p) => p.title,
            onSelect: (pers) => ref
                .read(characterCreationProvider.notifier)
                .updateWith(personality: pers),
          ),
          const SizedBox(height: _verticalItemSpacing),

          // --- Behaviour ---
          _buildSelectionItem<Behaviour>(
            context: context,
            ref: ref,
            title: 'Which behaviour\'s match your companion', // Note: grammar in UI is behaviour's
            iconPath: 'assets/icons/behaviour_icon.svg', // ** UPDATE ICON PATH (e.g., token_mind.svg?) **
            options: masterData.behaviours,
            selected: characterProvider.behaviour,
            optionToString: (b) => b.title,
            onSelect: (beh) => ref
                .read(characterCreationProvider.notifier)
                .updateWith(behaviour: beh),
          ),
          const SizedBox(height: _verticalItemSpacing), // Add space at the bottom
        ],
      ),
    );
  }

  // --- New Widget for the Selection Item (Title + Selector Bar) ---
  Widget _buildSelectionItem<T>({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String iconPath,
    required List<T> options,
    required T? selected,
    required String Function(T) optionToString,
    required Function(T) onSelect,
  }) {
    final String displayValue = selected != null ? optionToString(selected) : 'Select';
    final Color displayColor = selected != null ? _selectorTextColor : _selectPlaceholderColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Text (Question)
        Text(
          title,
          style: const TextStyle(
            color: _titleColor,
            fontSize: 16, // Adjust as needed
            fontWeight: FontWeight.w400, // Adjust as needed
          ),
        ),
        const SizedBox(height: _titleBottomSpacing),

        // Selector Bar (Tappable)
        Material(
          color: Color(0xff23222F),
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {
              // --- Determine which popup to show based on type T or title ---
              // Using the generic popup for all these options by default
              _showOptionPopup<T>(
                context,
                ref,
                title.split(' ').last, // Use last word of title for popup title (e.g., "Category")
                options,
                optionToString: optionToString,
                onSelect: onSelect,
                // Pass selected if needed by the popup UI
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  // Icon
                  SvgPicture.asset(
                    iconPath,
                    width: _iconSize,
                    height: _iconSize,
                    colorFilter: const ColorFilter.mode(
                      _selectorIconColor,
                      BlendMode.srcIn,
                    ),
                    // Optional: Add error builder
                    placeholderBuilder: (context) => Icon(
                      Icons.question_mark, // Placeholder icon
                      size: _iconSize,
                      color: _selectorIconColor,
                    ),
                  ),
                  const SizedBox(width: 12), // Space between icon and text

                  // Selected Value / Placeholder Text
                  Expanded( // Allow text to expand
                    child: Text(
                      displayValue,
                      style: TextStyle(
                        color: Color(0xFF969696),
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                  ),
                  const SizedBox(width: 8), // Space before chevron

                  // Chevron Icon
                  const Icon(
                    Icons.chevron_right,
                    color: _chevronColor,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Popup Functions (Copied from original code, ensure they are compatible) ---
  // Make sure the styles inside these popups also match your desired theme

  // Generic Option Popup (using Wrap for chips - adjust if needed)
  void _showOptionPopup<T>(
      BuildContext context,
      WidgetRef ref,
      String title, // Changed to popup title (e.g., "Category")
      List<T> options, {
        required String Function(T) optionToString,
        required Function(T) onSelect,
        // T? selected, // Added selected parameter if needed for UI highlighting
      }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    const double horizontalPadding = 24.0; // Use consistent padding
    const double verticalPadding = 24.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF141416), // Dark background for popup
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: verticalPadding,
                    bottom: verticalPadding / 1.5, // Less bottom padding for title
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Choose a $title",
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
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                // Use Flexible + SingleChildScrollView for scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        bottom: 10, // Padding below wrap
                        top: 5, // Padding above wrap
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 10, // Horizontal space between chips
                          runSpacing: 14, // Vertical space between chip lines
                          alignment: WrapAlignment.start,
                          children: options.map((option) {
                            // final isSelected = selected == option; // Determine if current option is selected
                            return GestureDetector(
                              onTap: () {
                                onSelect(option);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF23222F), // Chip background color
                                  borderRadius: BorderRadius.circular(100), // Pill shape
                                  // Optional: Add border if selected
                                  // border: isSelected ? Border.all(color: _selectorIconColor, width: 1.5) : null,
                                ),
                                child: Text(
                                  optionToString(option),
                                  style: const TextStyle(
                                    color: Color(0xFFE5E5E5), // Chip text color
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom padding to avoid system navigation
                SizedBox(
                  height: MediaQuery.paddingOf(context).bottom > 0
                      ? MediaQuery.paddingOf(context).bottom // Respect safe area
                      : verticalPadding, // Fallback padding
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
