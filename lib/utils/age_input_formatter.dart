import 'package:flutter/services.dart';

class TwoDigitRangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  TwoDigitRangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty value
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Only allow digits
    if (!RegExp(r'^\d*$').hasMatch(newValue.text)) {
      return oldValue;
    }

    // Don't allow more than 2 digits
    if (newValue.text.length > 2) {
      return oldValue;
    }

    // For 1-digit input, check if it could potentially be valid
    if (newValue.text.length == 1) {
      final digit = int.parse(newValue.text);
      final minFirstDigit = min ~/ 10;
      final maxFirstDigit = max ~/ 10;

      if (digit < minFirstDigit || digit > maxFirstDigit) {
        return oldValue;
      }
    }

    // For 2-digit input, check the full range
    if (newValue.text.length == 2) {
      final number = int.parse(newValue.text);
      if (number < min || number > max) {
        return oldValue;
      }
    }

    return newValue;
  }
}
