import 'package:flutter/material.dart';
import 'package:guftagu_mobile/config/app_color.dart';

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
}
