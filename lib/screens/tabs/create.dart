import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/character_creation_provider.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/prev_next_buttons.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/step_0_widget.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/step_1_widget.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/step_2_widget.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/step_3_widget.dart';
import 'package:guftagu_mobile/screens/tabs/widgets/step_4_widget.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class CreateTab extends ConsumerWidget {
  const CreateTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(characterCreationProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and current step number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Character Creation',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC9C9C9),
                        ),
                      ),
                      5.pw,
                      SvgPicture.asset(
                        Assets.svgs.icArrowRight,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFC9C9C9),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'STEP',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                      6.pw,
                      Text(
                        '${provider.index + 1 > 4 ? 4 : provider.index + 1}/4', // Ensure it doesn't exceed 4
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            35.ph,
            // PageView for step content
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: provider.pageController,
                onPageChanged: (index) {
                  ref
                      .read(characterCreationProvider.notifier)
                      .updateIndex(index);
                },
                children: [
                  Step0Widget(),
                  Step1Widget(),
                  const Step2Widget(),
                  const Step3Widget(),
                  const Step4Widget(),
                ],
              ),
            ),

            const PrevNextButtons(),
          ],
        ),
      ),
    );
  }
}
