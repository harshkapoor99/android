import 'package:flutter/material.dart';

class EmailOrPhoneValidator {
  static String? validate(String? value, {BuildContext? context}) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email or phone number';
    }

    // Trim the value to remove any leading/trailing whitespace
    final trimmedValue = value.trim();

    // Check if it's a valid email
    if (isValidEmail(trimmedValue)) {
      return null;
    }

    // Check if it's a valid phone number
    if (isValidPhoneNumber(trimmedValue)) {
      return null;
    }

    // If neither email nor phone is valid
    return 'Please enter a valid email or phone number';
  }

  static bool isValidEmail(String email) {
    // A more comprehensive email regex pattern
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    // Remove all non-digit characters
    // final digitsOnly = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final digitsOnly = phone;

    // Check if it's a valid international phone number (with + and 8-15 digits)
    if (RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(digitsOnly)) {
      return true;
    }

    // Check if it's a valid phone number without country code (adjust length as needed)
    if (RegExp(r'^[0-9]{8,15}$').hasMatch(digitsOnly)) {
      return true;
    }

    return false;
  }
}
