import 'package:flutter/material.dart';
import 'package:guftagu_mobile/screens/tabs/Step0Widget.dart';
import 'package:guftagu_mobile/screens/tabs/Step1Widget.dart';
import 'package:guftagu_mobile/screens/tabs/Step2Widget.dart';
import 'package:guftagu_mobile/screens/tabs/Step3Widget.dart';
import 'package:guftagu_mobile/screens/tabs/Step4Widget.dart';
import '../../components/next_button.dart';

class CreateTab extends StatefulWidget {
  const CreateTab({super.key});

  @override
  State<CreateTab> createState() => _CreateTab();
}

class _CreateTab extends State<CreateTab> {
  final PageController _pageController = PageController(); // Add PageController
  int currentStep = 0;

  void _nextStep() {
    if (currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Character Created!");
    }
  }

  void _prevStep() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFC9C9C9),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'STEP',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFFA3A3A3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${currentStep + 1 > 4 ? 4 : currentStep + 1}/4', // Ensure it doesn't exceed 4
                        style: TextStyle(
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

              // PageView for step content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentStep = index;
                    });
                  },
                  children: [
                    Step0Widget(),
                    Step1Widget(),
                    Step2Widget(),
                    Step3Widget(),
                    Step4Widget(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    TextButton(
                      onPressed: _prevStep,
                      child: const Text(
                        "Previous",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),

                  NextButton(
                    label:
                    currentStep == 3
                        ? "Preview"
                        : (currentStep == 4 ? "Create" : "Next"),
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