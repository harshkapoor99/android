import 'package:flutter/material.dart';
import 'package:guftagu_mobile/configs/app_color.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/l10n/app_localizations.gen.dart';

extension ContextLess on BuildContext {
  NavigatorState get nav {
    return Navigator.of(this);
  }

  ColorScheme get color {
    return Theme.of(this).colorScheme;
  }

  AppColors get colorExt {
    return Theme.of(this).extension<AppColors>()!;
  }

  AppTextStyle get appTextStyle {
    return AppTextStyle(this);
  }

  AppLocalizations get l {
    return AppLocalizations.of(this);
  }
}
