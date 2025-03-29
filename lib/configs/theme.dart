import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        tertiary: AppStaticColors.accentColor,
        button:
            isDarkTheme
                ? AppStaticColors.primaryColor
                : AppStaticColors.primaryColor,
        buttonText: AppStaticColors.whiteColor,
        textPrimary:
            isDarkTheme
                ? AppStaticColors.whiteColor
                : AppStaticColors.blackColor,
        textSecondary:
            isDarkTheme
                ? AppStaticColors.whiteColor
                : AppStaticColors.grayColor,
        textHint:
            isDarkTheme
                ? AppStaticColors.accentColor
                : AppStaticColors.grayColor,
        background: isDarkTheme ? Colors.black : const Color(0xFFF3F4F6),
        border:
            isDarkTheme ? AppStaticColors.grayColor : AppStaticColors.grayColor,
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
        isDarkTheme ? Colors.black : const Color(0xFFF3F4F6),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor:
          isDarkTheme ? AppStaticColors.blackColor : AppStaticColors.whiteColor,
      titleTextStyle: TextStyle(
        color:
            isDarkTheme
                ? AppStaticColors.whiteColor
                : AppStaticColors.blackColor,
        fontSize: 16.sp,
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
    cardTheme: CardTheme(
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
      borderRadius: BorderRadius.circular(12.h),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: const BorderSide(color: AppStaticColors.primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: const BorderSide(color: AppStaticColors.redColor),
    ),
  );
}
