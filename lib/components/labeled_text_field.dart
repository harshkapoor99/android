import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color labelColor;
  final Color fillColor;
  final TextStyle? labelTextStyle;
  final TextStyle? inputTextStyle;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final TextInputType keyboardType; // <-- ADDED THIS LINE
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
    this.labelTextStyle,
    this.inputTextStyle = const TextStyle(color: Colors.white),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius = 10.0,
    this.keyboardType =
        TextInputType.text, // <-- ADDED THIS LINE (with default)
    this.obscureText = false,
    this.hintText,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle =
        labelTextStyle ??
        TextStyle(fontSize: 16, height: 1.0, color: labelColor);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: labelStyle),
            const SizedBox(height: 16),
            TextField(
              inputFormatters: inputFormatters,
              controller: controller,
              style: inputTextStyle,
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.sentences,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xFF969696)),
                filled: true,
                fillColor: fillColor,
                contentPadding: contentPadding,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
