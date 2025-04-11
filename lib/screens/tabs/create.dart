import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/choice_option_selector.dart';
import '../../components/labeled_text_field.dart';
import '../../components/image_option_selector.dart';
import '../../components/next_button.dart';

class CreateTab extends StatefulWidget {
  const CreateTab({super.key});

  @override
  State<CreateTab> createState() => _CreateTab();
}

class _CreateTab extends State<CreateTab> {
  final TextEditingController _nameController = TextEditingController();
  String selectedAge = '';
  String selectedGender = '';
  String selectedStyle = '';
  String selectedOrientation = '';
  String selectedLanguage = '';
  int currentStep = 0;

  final List<String> ageOptions = ['Teen (+18)', '20s', '30s', '40-55s'];

  final List<Map<String, dynamic>> genderOptions = [
    {
      'label': 'Female',
      'image': 'assets/images/model/mod_img5.jpeg',
      'icon': 'assets/icons/female.png',
      'value': 'female',
    },
    {
      'label': 'Male',
      'image': 'assets/images/onboarding/ob_img14.webp',
      'icon': 'assets/icons/male.png',
      'value': 'male',
    },
    {
      'label': 'Others',
      'image': 'assets/images/les.png',
      'icon': 'assets/icons/lesbo.png',
      'value': 'others',
    },
  ];

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
  final List<String> languageOptions = ['English', 'Hinglish'];

  void _nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    } else {
      debugPrint("Name: ${_nameController.text}");
      debugPrint("Age: $selectedAge");
      debugPrint("Gender: $selectedGender");
      debugPrint("Style: $selectedStyle");
      debugPrint("Orientation: $selectedOrientation");
      debugPrint("Language: $selectedLanguage");
      // Navigate or finish action
    }
  }

  void _prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  Widget buildStepContent(int step) {
    switch (step) {
      case 0:
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
                style: GoogleFonts.openSans(
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
                style: GoogleFonts.poppins(
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
      case 1:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Style',
                style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFF2F2F2),
                ),
              ),
              const SizedBox(height: 12),
              ChoiceOptionSelector(
                options: orientationOptions,
                selected: selectedOrientation,
                onSelected: (value) => setState(() => selectedOrientation = value),
              ),
              const SizedBox(height: 24),
              Text(
                'Primary Language',
                style: GoogleFonts.poppins(
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
      case 2:
        return Center(
          child: Text(
            "Step 3 Content",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        );
      case 3:
        return Center(
          child: Text(
            "Preview Step or Final Submit",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and current step number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Character Creation',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFC9C9C9),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'STEP',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: const Color(0xFFA3A3A3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${currentStep + 1}/4',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Expanded(child: buildStepContent(currentStep)),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    TextButton(
                      onPressed: _prevStep,
                      child: const Text("Previous", style: TextStyle(color: Colors.white)),
                    )
                  else
                    const SizedBox(),

                  NextButton(
                    label: currentStep == 3 ? "Finish" : "Next",
                    onPressed: _nextStep,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
