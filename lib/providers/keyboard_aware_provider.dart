import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/keyboard_aware_provider.gen.dart';

@Riverpod(keepAlive: false)
class KeyboardAware extends _$KeyboardAware {
  final KeyboardVisibilityController _keyboardVisibility =
      KeyboardVisibilityController();
  @override
  double build() {
    _keyboardVisibility.onChange.listen(_handleKeyboardVisibilityChange);
    return 80;
  }

  void _handleKeyboardVisibilityChange(bool isVisible) {
    if (isVisible) {
      state = 0;
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        state = 80;
      });
    }
  }
}
