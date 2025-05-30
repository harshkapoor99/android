import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? hintText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const LabeledTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
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
