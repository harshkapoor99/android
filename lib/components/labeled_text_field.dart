import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color labelColor;
  final Color fillColor;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? hintText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const LabeledTextField({
    super.key,
    required this.controller,
    required this.label,
    this.labelColor = const Color(0xFFF2F2F2),
    this.fillColor = const Color(0xFF23222F),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.borderRadius = 10.0,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.hintText,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.appTextStyle.characterGenLabel),
            const SizedBox(height: 16),
            TextField(
              inputFormatters: inputFormatters,
              controller: controller,
              style: context.appTextStyle.textSemibold,
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.sentences,
              maxLength: maxLength,
              decoration: AppConstants.inputDecoration(
                context,
              ).copyWith(hintText: hintText),
            ),
          ],
        );
      },
    );
  }
}
