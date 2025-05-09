import 'package:flutter/material.dart';

import 'package:guftagu_mobile/configs/theme.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class AppTextStyle {
  final BuildContext context;
  AppTextStyle(this.context);

  TextStyle get title => TextStyle(
    color: colors(context).textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  TextStyle get subTitle => TextStyle(
    color: colors(context).textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  TextStyle get text => TextStyle(
    color: colors(context).textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  TextStyle get textSemibold => TextStyle(
    color: colors(context).textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  TextStyle get textBold => TextStyle(
    color: colors(context).textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  TextStyle get textSmall => TextStyle(
    color: colors(context).textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get labelText => TextStyle(
    color: colors(context).buttonText,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  TextStyle get buttonText => TextStyle(
    color: colors(context).buttonText,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  TextStyle get hintText => TextStyle(
    color: colors(context).textHint,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  TextStyle get appBarText => TextStyle(
    color: colors(context).textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  TextStyle get characterGenLabel =>
      TextStyle(fontSize: 16, color: context.colorExt.textPrimary);
}
