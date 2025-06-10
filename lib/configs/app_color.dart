import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color button;
  final Color buttonText;
  final Color textPrimary;
  final Color invertTextPrimary;
  final Color textHint;
  final Color border;
  final Color bubble;
  final Color surface;
  final Color sheet;
  final Color background;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.button,
    required this.buttonText,
    required this.textPrimary,
    required this.invertTextPrimary,
    required this.textHint,
    required this.border,
    required this.bubble,
    required this.surface,
    required this.sheet,
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
    Color? invertTextPrimary,
    Color? textHint,
    Color? border,
    Color? bubble,
    Color? surface,
    Color? sheet,
    Color? background,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      button: button ?? this.button,
      bubble: bubble ?? this.bubble,
      buttonText: buttonText ?? this.buttonText,
      textPrimary: textPrimary ?? this.textPrimary,
      invertTextPrimary: invertTextPrimary ?? this.invertTextPrimary,
      textHint: textHint ?? this.textHint,
      border: border ?? this.surface,
      surface: surface ?? this.surface,
      sheet: sheet ?? this.sheet,
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
      invertTextPrimary:
          Color.lerp(invertTextPrimary, other.invertTextPrimary, t) ??
          AppStaticColors.redColor,
      textHint:
          Color.lerp(textHint, other.textHint, t) ?? AppStaticColors.redColor,
      border: Color.lerp(border, other.border, t) ?? AppStaticColors.redColor,
      bubble: Color.lerp(bubble, other.bubble, t) ?? AppStaticColors.redColor,
      surface:
          Color.lerp(surface, other.surface, t) ?? AppStaticColors.redColor,
      sheet: Color.lerp(sheet, other.sheet, t) ?? AppStaticColors.redColor,
      background:
          Color.lerp(background, other.background, t) ??
          AppStaticColors.redColor,
    );
  }
}

class AppStaticColors {
  static const Color primaryColor = Color.fromARGB(255, 119, 0, 198);
  static const Color secondaryColor = Color(0xFF7517F8);
  static const Color accentColor = Color(0xFF00FFED);
  static const Color accentColorDark = Color.fromARGB(255, 0, 190, 178);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color lightWhiteColor = Color(0xFFA3A3A3);
  static const Color blackColor = Color(0xFF030712);
  static const Color darkBackground = Color.fromRGBO(3, 7, 18, 1);
  static const Color lightBackground = Color(0xFFF0F2F3);
  static const Color redColor = Color(0xffFF324B);
  static const Color border = Color(0xffcccccc);
  static const Color grayColor = Color(0xff23222F);
  static const Color lightGrayColor = Color.fromARGB(255, 211, 211, 211);
  static const Color sheetDark = Color(0xFF0D0D18);
  static const Color sheetLight = Color.fromARGB(255, 217, 217, 231);
  static const Color orangeColor = Color(0xFFFAA809);
  static const Color yellowColor = Color(0xFFFFEE06);
  static const Color greenColor = Color(0xFF00CA45);
  static const Color blueColor = Color(0xFF306AFF);
  static const Color darkBubble = Color(0xFF1F1F1F);
  static const Color lightBubble = Color.fromARGB(255, 217, 217, 231);
}
