import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';

class PrevNextButtons extends ConsumerWidget {
  const PrevNextButtons({super.key});

  void _nextStep(PageController pageController, int currentStep) {
    if (currentStep < 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Character Created!");
    }
  }

  void _prevStep(PageController pageController, int currentStep) {
    if (currentStep > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    final currentStep = provider.index;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep > 0)
          TextButton(
            onPressed: () => _prevStep(provider.pageController, currentStep),
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

        GradientButton(
          disabled: !ref.watch(nextButtonStatusProvider),
          width: 132,
          title:
              currentStep == 3
                  ? "Preview"
                  : (currentStep == 4 ? "Create" : "Next"),
          onTap: () => _nextStep(provider.pageController, currentStep),
        ),
      ],
    );
  }
}
