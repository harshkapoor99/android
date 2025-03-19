import 'package:flutter/material.dart';

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
    this.suffixIcon,
    this.prefix,
    this.maxLength,
    this.onChanged,
    this.focusNode,
    this.readOnly = false,
    this.disabled = false,
    this.autofocus = false,
  });

  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines, maxLength;
  final Widget? suffixIcon, prefix;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool disabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xff1F1F2A),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF23222F)),
        ),
      ),
    );
  }
}
