import 'package:flutter/material.dart';

class ChoiceOptionSelector<T> extends StatelessWidget {
  final List<T> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final double spacing;
  final String Function(T)? optionToString;

  const ChoiceOptionSelector({
    super.key,
    required this.options,
    this.selected,
    required this.onSelected,
    this.selectedColor = const Color(0xFFA3A3A3),
    this.unselectedColor = const Color(0xFF23222F),
    this.selectedTextStyle = const TextStyle(color: Colors.black),
    this.unselectedTextStyle = const TextStyle(color: Colors.white),
    this.spacing = 10.0,
    this.optionToString,
  });

  String _getOptionText(T option) {
    if (optionToString != null) {
      return optionToString!(option);
    }
    return option.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      children:
          options.map((option) {
            final isSelected = selected == option;

            return ChoiceChip(
              label: Text(_getOptionText(option)),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) => onSelected(option),
              selectedColor: selectedColor,
              backgroundColor: unselectedColor,
              labelStyle: isSelected ? selectedTextStyle : unselectedTextStyle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
            );
          }).toList(),
    );
  }
}
