import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final double width;
  final double height;
  final Color labelColor;
  final Color fillColor;
  final TextStyle? labelTextStyle;
  final TextStyle? inputTextStyle;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;

  const LabeledTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.width = 374,
    this.height = 90,
    this.labelColor = const Color(0xFFF2F2F2),
    this.fillColor = const Color(0xFF23222F),
    this.labelTextStyle,
    this.inputTextStyle = const TextStyle(color: Colors.white),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelStyle = labelTextStyle ??
        GoogleFonts.openSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.0,
          color: labelColor,
        );

    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            style: inputTextStyle,
            decoration: InputDecoration(
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
      ),
    );
  }
}
