import 'package:flutter/material.dart';

import 'package:guftagu_mobile/configs/app_color.dart';

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;

ThemeData getAppTheme({
  required BuildContext context,
  required bool isDarkTheme,
}) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        primary:
            isDarkTheme
                ? AppStaticColors.primaryColor
                : AppStaticColors.primaryColor,
        secondary: AppStaticColors.secondaryColor,
        tertiary:
            isDarkTheme
                ? AppStaticColors.accentColor
                : AppStaticColors.accentColorDark,
        button:
            isDarkTheme
                ? AppStaticColors.primaryColor
                : AppStaticColors.primaryColor,
        buttonText: AppStaticColors.whiteColor,
        textPrimary:
            isDarkTheme
                ? AppStaticColors.whiteColor
                : AppStaticColors.blackColor,
        invertTextPrimary:
            isDarkTheme
                ? AppStaticColors.blackColor
                : AppStaticColors.whiteColor,
        textHint:
            isDarkTheme
                ? AppStaticColors.lightWhiteColor
                : AppStaticColors.grayColor,
        background:
            isDarkTheme
                ? AppStaticColors.darkBackground
                : AppStaticColors.lightBackground,
        border:
            isDarkTheme ? AppStaticColors.border : AppStaticColors.grayColor,
        bubble:
            isDarkTheme
                ? AppStaticColors.darkBubble
                : AppStaticColors.lightBubble,
        surface:
            isDarkTheme
                ? AppStaticColors.grayColor
                : AppStaticColors.lightGrayColor,
        sheet:
            isDarkTheme
                ? AppStaticColors.sheetDark
                : AppStaticColors.sheetLight,
      ),
    ],
    fontFamily: 'OpenSans',
    colorScheme:
        isDarkTheme
            ? ColorScheme.fromSeed(
              seedColor: AppStaticColors.primaryColor,
              surface: AppStaticColors.blackColor,
              brightness: Brightness.dark,
            )
            : ColorScheme.fromSeed(
              seedColor: AppStaticColors.primaryColor,
              surface: AppStaticColors.whiteColor,
              brightness: Brightness.light,
            ),
    useMaterial3: true,
    unselectedWidgetColor:
        isDarkTheme ? AppStaticColors.accentColor : AppStaticColors.grayColor,
    scaffoldBackgroundColor:
        isDarkTheme
            ? AppStaticColors.darkBackground
            : AppStaticColors.lightBackground,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor:
          isDarkTheme ? AppStaticColors.blackColor : AppStaticColors.whiteColor,
      titleTextStyle: TextStyle(
        color:
            isDarkTheme
                ? AppStaticColors.whiteColor
                : AppStaticColors.blackColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'OpenSans',
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: false,
      elevation: 0,
      iconTheme: IconThemeData(
        color:
            isDarkTheme
                ? AppStaticColors.whiteColor
                : AppStaticColors.blackColor,
      ),
    ),
    inputDecorationTheme: inputDecorationTheme(isDarkTheme: isDarkTheme),
    cardTheme: CardThemeData(
      color:
          isDarkTheme
              ? AppStaticColors.primaryColor.withAlpha(50)
              : AppStaticColors.primaryColor.withAlpha(50),
    ),
  );
}

InputDecorationTheme inputDecorationTheme({required bool isDarkTheme}) {
  Color borderColor =
      isDarkTheme
          ? AppStaticColors.accentColor.withValues(alpha: .2)
          : AppStaticColors.grayColor.withValues(alpha: .2);
  return InputDecorationTheme(
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(
      color: AppStaticColors.grayColor,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    ),
    filled: false,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppStaticColors.primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppStaticColors.redColor),
    ),
  );
}
