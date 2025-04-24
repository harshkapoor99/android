import 'package:flutter/material.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({
    super.key,
    this.hint = '',
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.label,
    this.suffix,
    this.prefix,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.readOnly = false,
    this.disabled = false,
    this.autofocus = false,
    this.prefixText,
    this.sufixText,
    this.textCapitalization = TextCapitalization.none,
  });

  final String? hint;
  final String? label;
  final String? prefixText, sufixText;
  final TextEditingController? controller;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines, maxLength;
  final Widget? suffix, prefix;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool disabled;
  final bool autofocus;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      autofocus: autofocus,
      enabled: !disabled,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      focusNode: focusNode,
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.center,
      obscureText: obscureText!,
      onChanged: onChanged,
      validator: validator,
      style: context.appTextStyle.text,
      decoration: InputDecoration(
        prefixText: prefixText,
        suffixText: sufixText,
        prefix: prefix,
        suffix: suffix,
        prefixStyle: context.appTextStyle.text,
        filled: true,
        fillColor: context.colorExt.border,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.colorExt.border),
        ),
      ),
    );
  }
}
