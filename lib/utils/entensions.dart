import 'package:flutter/material.dart';

//converts
extension NumModifier on num {
  Duration get miliSec {
    return Duration(milliseconds: int.parse(toString()));
  }

  /// Puts A Vertical Spacer With the value
  SizedBox get ph {
    return SizedBox(height: toDouble());
  }

  /// Puts A Horizontal Spacer With the value
  SizedBox get pw {
    return SizedBox(width: toDouble());
  }
}

extension StringExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringExtensions on String? {
  bool get hasValue {
    return this != null && this!.trim().isNotEmpty;
  }
}

extension ListExtensions<T> on List<T> {
  // Method to return all elements except the last one
  List<T> allExceptLast() {
    if (isEmpty) {
      return []; // Return an empty list if the list is empty
    }
    return sublist(0, length - 1); // Return all elements except the last one
  }
}

extension DateTimeExtensions on DateTime {
  bool get isAfterToday {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return isAfter(today);
  }

  bool get isBeforeToday {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return isBefore(today);
  }
}
