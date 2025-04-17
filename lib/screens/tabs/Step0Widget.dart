import 'package:flutter/material.dart';
import '../../components/choice_option_selector.dart';
import '../../components/image_option_selector.dart';
import '../../components/labeled_text_field.dart';

class Step0Widget extends StatefulWidget {
  const Step0Widget({super.key});

  @override
  State<Step0Widget> createState() => _Step0WidgetState();
}

class _Step0WidgetState extends State<Step0Widget> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> ageOptions = ['Teen (+18)', '20s', '30s', '40-55s'];
  String selectedAge = '';
  String selectedGender = '';
  final List<Map<String, dynamic>> genderOptions = [
    {
      'label': 'Female',
      'image': 'assets/images/model/mod_img5.jpeg',
      'icon': 'assets/icons/female.svg',
      'value': 'female',
    },
    {
      'label': 'Male',
      'image': 'assets/images/onboarding/ob_img14.webp',
      'icon': 'assets/icons/male.svg',
      'value': 'male',
    },
    {
      'label': 'Others',
      'image': 'assets/images/les.png',
      'icon': 'assets/icons/lesbo.svg',
      'value': 'others',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            controller: _nameController,
            label: 'Character Name',
          ),
          const SizedBox(height: 24),
          Text(
            'Choose Age',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 20),
          ChoiceOptionSelector(
            options: ageOptions,
            selected: selectedAge,
            onSelected: (age) => setState(() => selectedAge = age),
          ),
          const SizedBox(height: 24),
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF2F2F2),
            ),
          ),
          const SizedBox(height: 12),
          ImageOptionSelector(
            options: genderOptions,
            selected: selectedGender,
            onChanged: (gender) => setState(() => selectedGender = gender),
          ),
        ],
      ),
    );
  }
}
