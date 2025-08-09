import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class RechargeCoinsDialog extends StatelessWidget {
  const RechargeCoinsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Dialog shape and background color
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: context.colorExt.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.colorExt.sheet),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Diamond icon
            Center(
              child: SvgPicture.asset(
                Assets.svgs.icDiamonGold,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              "You don't have enough coins.\nKindly recharge.",
              textAlign: TextAlign.center,
              style: context.appTextStyle.textBold.copyWith(
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),

            // const Align(
            //   alignment: Alignment.center,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // List of benefits
            //       BenefirRow(text: 'Unlimited Chat'),
            //       BenefirRow(text: 'Unlock AI Calling'),
            //       BenefirRow(text: 'Unlock Images & Videos'),
            //       BenefirRow(text: 'Personalized Experience'),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),

            // Recharge Now Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5f3dd9), Color(0xFF9047f3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: GradientButton(
                title: "Recharge Now",
                onTap: () {
                  // Handle button tap
                  context.nav.pop();
                  context.nav.pushNamed(Routes.subscription);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
