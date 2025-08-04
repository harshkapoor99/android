import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/call_graph_ui/bars.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/timer_widget.dart';
import 'package:guftagu_mobile/components/wallet_coin_wiget.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/call_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class CallScreen extends ConsumerWidget {
  const CallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(callProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(callProvider.notifier).stopCall();
          ref.invalidate(callProvider);
        }
      },
      child: Scaffold(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),

                  child: NetworkImageWithPlaceholder(
                    imageUrl: provider.character?.imageGallery.first.url ?? "",
                    placeholder: SvgPicture.asset(
                      Assets.svgs.icProfilePlaceholder,
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                    errorWidget: SvgPicture.asset(
                      Assets.svgs.icProfilePlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              10.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.character?.name ?? "",
                    style: context.appTextStyle.textBold,
                  ),
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
              const WalletCoinWiget(),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(105),
                              child: NetworkImageWithPlaceholder(
                                imageUrl:
                                    provider
                                        .character
                                        ?.imageGallery
                                        .first
                                        .url ??
                                    "",
                                placeholder: SvgPicture.asset(
                                  Assets.svgs.icProfilePlaceholder,
                                  fit: BoxFit.cover,
                                ),
                                fit: BoxFit.cover,
                                errorWidget: SvgPicture.asset(
                                  Assets.svgs.icProfilePlaceholder,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.ph,
                  provider.isCallStarted && provider.callStartTime != null
                      ? TimerWidget(startTime: provider.callStartTime!)
                      : const Text("Connecting..."),
                  20.ph,
                  Text(provider.isSilent ? "Silent" : "Taking"),
                  Text("Recording: ${provider.isRecording}"),
                  StreamBuilder(
                    stream: provider.recorder.silenceChangedEvents,
                    builder:
                        (context, snapshot) =>
                            Text("Decibel: ${snapshot.data?.decibel}"),
                  ),
                  Text("InFlight: ${provider.inFlight}"),
                  Text("Player: ${provider.playerStatus.name}"),
                  if (kDebugMode) const Bars(),
                  // SvgPicture.asset(Assets.svgs.icAudioSpectrum, width: 150),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircleButton(
                        context,
                        SvgPicture.asset(Assets.svgs.icChat, width: 20),
                        context.colorExt.surface,
                        onPressed: context.nav.pop,
                      ),
                      _buildCircleButton(
                        context,
                        const Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 30,
                        ),
                        const Color(0xFFFC015B),
                        size: 60,
                        onPressed: () {
                          context.nav.pop();
                        },
                      ),
                      _buildCircleButton(
                        context,
                        provider.isSpeakerOn
                            ? SvgPicture.asset(
                              Assets.svgs.icSpeakerGrad,
                              width: 20,
                            )
                            : SvgPicture.asset(
                              Assets.svgs.icSpeaker,
                              width: 20,
                            ),
                        context.colorExt.surface,
                        onPressed:
                            () =>
                                ref.read(callProvider.notifier).toggleSpeaker(),
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
