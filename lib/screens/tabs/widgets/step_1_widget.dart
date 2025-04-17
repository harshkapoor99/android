import 'package:flutter/material.dart';
import 'package:guftagu_mobile/utils/entensions.dart';
import '../../../components/choice_option_selector.dart';
import '../../../components/image_option_selector.dart';

class Step1Widget extends StatefulWidget {
  const Step1Widget({super.key});

  @override
  State<Step1Widget> createState() => _Step1WidgetState();
}

class _Step1WidgetState extends State<Step1Widget> {
  String selectedStyle = '';
  final List<Map<String, dynamic>> styleOptions = [
    {
      'label': 'Realistic',
      'image': 'assets/images/model/mod_img9.png',
      'value': 'realistic',
    },
    {
      'label': 'Animie',
      'image': 'assets/images/model/mod_img10.png',
      'value': 'anime',
    },
  ];
  final List<String> orientationOptions = ['Straight', 'Gay', 'Lesbian'];
  String selectedOrientation = '';
  String selectedLanguage = '';
  final List<String> languageOptions = ['English', 'Hinglish'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Style',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          12.ph,
          ImageOptionSelector(
            options: styleOptions,
            selected: selectedStyle,
            onChanged: (style) => setState(() => selectedStyle = style),
          ),
          24.ph,
          const Text(
            'Sexual Orientation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          12.ph,
          ChoiceOptionSelector(
            options: orientationOptions,
            selected: selectedOrientation,
            onSelected: (value) => setState(() => selectedOrientation = value),
          ),
          24.ph,
          const Text(
            'Primary Language',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF2F2F2),
            ),
          ),
          12.ph,
          ChoiceOptionSelector(
            options: languageOptions,
            selected: selectedLanguage,
            onSelected: (value) => setState(() => selectedLanguage = value),
          ),
        ],
      ),
    );
  }
}
