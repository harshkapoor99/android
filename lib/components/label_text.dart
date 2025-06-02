import 'package:flutter/material.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class LabelText extends StatelessWidget {
  const LabelText(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // TODO: add left: 8.0 to padding
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(label, style: context.appTextStyle.characterGenLabel),
    );
  }
}
