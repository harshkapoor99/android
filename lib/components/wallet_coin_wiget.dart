import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/wallet_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class WalletCoinWiget extends ConsumerWidget {
  const WalletCoinWiget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    return GestureDetector(
      onTap: () => context.nav.pushNamed(Routes.subscription),
      child: Row(
        spacing: 5,
        children: [
          SvgPicture.asset(Assets.svgs.icDiamonGold),
          AnimatedFlipCounter(
            duration: const Duration(milliseconds: 500),
            value: wallet.coins.ceil(),
            textStyle: context.appTextStyle.buttonText,
          ),
          // Text(
          //   wallet.coins.ceil().toString(),
          //   style: context.appTextStyle.buttonText,
          // ),
          if (kDebugMode)
            Text(
              wallet.coins.toStringAsPrecision(7),
              style: context.appTextStyle.textSmall,
            ),
        ],
      ),
    );
  }
}
