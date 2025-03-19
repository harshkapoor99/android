import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color button;
  final Color buttonText;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final Color background;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.button,
    required this.buttonText,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.background,
  });

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? button,
    Color? buttonText,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? border,
    Color? background,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      button: button ?? this.button,
      buttonText: buttonText ?? this.buttonText,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      border: border ?? this.border,
      background: background ?? this.background,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary:
          Color.lerp(primary, other.primary, t) ?? AppStaticColors.redColor,
      secondary:
          Color.lerp(secondary, other.secondary, t) ?? AppStaticColors.redColor,
      tertiary:
          Color.lerp(tertiary, other.tertiary, t) ?? AppStaticColors.redColor,
      button: Color.lerp(button, other.button, t) ?? AppStaticColors.redColor,
      buttonText:
          Color.lerp(buttonText, other.buttonText, t) ??
          AppStaticColors.redColor,
      textPrimary:
          Color.lerp(textPrimary, other.textPrimary, t) ??
          AppStaticColors.redColor,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ??
          AppStaticColors.redColor,
      textHint:
          Color.lerp(textHint, other.textHint, t) ?? AppStaticColors.redColor,
      border: Color.lerp(border, other.border, t) ?? AppStaticColors.redColor,
      background:
          Color.lerp(background, other.background, t) ??
          AppStaticColors.redColor,
    );
  }
}

class AppStaticColors {
  static const Color primaryColor = Color(0xFF9D00C6);
  static const Color secondaryColor = Color(0xFF7517F8);
  static const Color accentColor = Color(0xFF00FFED);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF030712);
  static const Color redColor = Color(0xffFF324B);
  static const Color grayColor = Color(0xff23222F);
  static const Color orangeColor = Color(0xFFFAA809);
  static const Color yellowColor = Color(0xFFFFEE06);
  static const Color greenColor = Color(0xFF00CA45);
  static const Color blueColor = Color(0xFF306AFF);
}
