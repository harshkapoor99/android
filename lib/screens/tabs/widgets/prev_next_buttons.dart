import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/providers/my_ai_provider.dart';
import 'package:guftagu_mobile/providers/tab.dart';

class PrevNextButtons extends ConsumerWidget {
  const PrevNextButtons({super.key});

  void _nextStep(
    PageController pageController,
    int currentStep,
    WidgetRef ref,
  ) {
    if (currentStep < 4) {
      if (currentStep == 3) {
        ref.read(characterCreationProvider.notifier).createCharacter();
      }
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ref.read(characterCreationProvider.notifier).selectCharacterImage().then((
        res,
      ) {
        if (res.isSuccess) {
          ref.read(myAiProvider.notifier).fetchMyAis();
          ref.read(tabIndexProvider.notifier).changeTab(2);
          ref.read(characterCreationProvider.notifier).resetState();
        }
      });
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
          currentStep != 4
          // If currentStep is NOT 4, build the TextButton
              ? TextButton(
            onPressed: () => _prevStep(provider.pageController, currentStep),
            child: const Text( // The text is always "Previous" when the button is shown
              "Previous",
              style: TextStyle(
                color: Colors.white, // Use your desired style
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
          // If currentStep IS 4, build an empty widget (like SizedBox.shrink)
              : const SizedBox.shrink() // This effectively hides the button
        else
          const SizedBox(),

        GradientButton(
          disabled: !ref.watch(nextButtonStatusProvider),
          width: 132,
          title:
              currentStep == 3
                  ? "Continue"
                  : (currentStep == 4 ? "Create" : "Next"),
          onTap: () => _nextStep(provider.pageController, currentStep, ref),
        ),
      ],
    );
  }
}
