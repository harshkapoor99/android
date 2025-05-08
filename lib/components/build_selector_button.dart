import 'package:flutter/material.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

/// A reusable selector button that displays a label and current value
/// with an arrow indicator for dropdowns/bottom sheets.
class BuildSelectorButton extends StatelessWidget {
  /// The label text displayed above the selector button
  final String label;

  /// The currently selected value to display in the button
  final String? selectedValue;

  /// Placeholder text to show when no value is selected
  final String placeholder;

  /// Callback function when the button is tapped
  final VoidCallback onTap;

  /// Optional custom style for the button
  final BoxDecoration? decoration;

  const BuildSelectorButton({
    Key? key,
    required this.label,
    this.selectedValue,
    this.placeholder = 'Select',
    required this.onTap,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the button
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),

        // The selector button itself
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration:
                decoration ??
                BoxDecoration(
                  color: context.colorExt.border,
                  borderRadius: BorderRadius.circular(8),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Selected value or placeholder
                Text(
                  selectedValue ?? placeholder,
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedValue != null ? Colors.white : Colors.grey,
                  ),
                ),

                // Arrow icon
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
