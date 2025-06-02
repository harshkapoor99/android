import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/call_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class CallScreen extends ConsumerWidget {
  const CallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(callProvider);
    return Scaffold(
      backgroundColor: context.colorExt.background,
      appBar: AppBar(
        backgroundColor: context.colorExt.background,
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                context.nav.pop();
              },
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: Assets.images.model.modImg1.provider(),
            ),
            10.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jaan", style: context.appTextStyle.textBold),
                Row(
                  children: [
                    5.pw,
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                      ),
                    ),
                    5.pw,
                    Text(
                      "Online",
                      style: context.appTextStyle.text.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // SvgPicture.asset(Assets.svgs.icDiamonGold, height: 20),
            // 5.pw,
            // Text(
            //   '1200',
            //   style: context.appTextStyle.textBold.copyWith(fontSize: 12),
            // ),
            20.pw,
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Assets.images.bgGradLarge.image(),
            Align(
              alignment: Alignment.topRight,
              child: Assets.images.bgGradSmall.image(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    children: [
                      //
                      SvgPicture.asset(Assets.svgs.bgCircleLarge),
                      Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(Assets.svgs.bgCircleSmall),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          maxRadius: 105,
                          backgroundImage:
                              Assets.images.model.modImg1.provider(),
                        ),
                      ),
                    ],
                  ),
                ),
                20.ph,
                const Text(
                  "12:36",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                20.ph,
                SvgPicture.asset(Assets.svgs.icAudioSpectrum, width: 150),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircleButton(
                      context,
                      SvgPicture.asset(Assets.svgs.icChat, width: 20),
                      context.colorExt.border,
                      onPressed: context.nav.pop,
                    ),
                    _buildCircleButton(
                      context,
                      const Icon(Icons.call_end, color: Colors.white, size: 30),
                      const Color(0xFFFC015B),
                      size: 60,
                      onPressed: context.nav.pop,
                    ),
                    _buildCircleButton(
                      context,
                      provider.isSpeakerOn
                          ? SvgPicture.asset(
                            Assets.svgs.icSpeakerGrad,
                            width: 20,
                          )
                          : SvgPicture.asset(Assets.svgs.icSpeaker, width: 20),
                      context.colorExt.border,
                      onPressed:
                          () => ref.read(callProvider.notifier).toggleSpeaker(),
                      enabled: provider.isSpeakerOn,
                    ),
                  ],
                ),
                30.ph,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(
    BuildContext context,
    Widget icon,
    Color color, {
    double size = 50,
    void Function()? onPressed,
    bool enabled = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: enabled ? context.colorExt.tertiary : color,
        ),
      ),
      child: IconButton(icon: icon, onPressed: onPressed),
    );
  }
}
