import 'package:flutter/material.dart';
import '../../components/choice_option_selector.dart';
import '../../components/image_option_selector.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Style',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 12),
          ImageOptionSelector(
            options: styleOptions,
            selected: selectedStyle,
            onChanged: (style) => setState(() => selectedStyle = style),
          ),
          const SizedBox(height: 24),
          Text(
            'Sexual Orientation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 12),
          ChoiceOptionSelector(
            options: orientationOptions,
            selected: selectedOrientation,
            onSelected:
                (value) => setState(() => selectedOrientation = value),
          ),
          const SizedBox(height: 24),
          Text(
            'Primary Language',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 12),
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