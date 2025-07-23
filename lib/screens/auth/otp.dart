import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/back_button.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/pin_put.dart';
import 'package:guftagu_mobile/components/timer.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/auth_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/print_debug.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  void verify(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!ref.read(authProvider).canVerify) return;
    ref
        .read(authProvider.notifier)
        .verifyOtp()
        .then((value) {
          if (value.isSuccess) {
            if (!value.response!.profile.fullName.hasValue) {
              context.nav.pushReplacementNamed(Routes.name);
            } else if (value.response!.characterTypeIds.isEmpty) {
              context.nav.pushReplacementNamed(Routes.interest);
            } else {
              context.nav.pushReplacementNamed(Routes.dashboard);
            }
            ref.read(authProvider.notifier).clearControllers();
          }
          AppConstants.showSnackbar(message: value.message, isSuccess: true);
        })
        .onError((error, stackTrace) {
          AppConstants.showSnackbar(message: error.toString(), isSuccess: true);
          printDebug(error);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(authProvider);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Assets.images.bgGrad.image(width: double.infinity),
              if (context.nav.canPop())
                BackButtonWidget(
                  onPop: ref.read(authProvider).otpControler.clear,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        context.l.otpVerify,
                        style: AppTextStyle(context).title,
                      ),
                    ),
                    20.ph,
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Opensans', // Change as needed
                            ),
                            children: [
                              TextSpan(
                                text:
                                    context.l.weSentOtp +
                                    "${provider.isEmail ? context.l.email : context.l.phonenumber} ",
                                style: context.appTextStyle.textSmall,
                              ),
                              TextSpan(
                                text: provider.credentialControler.text,
                                style: context.appTextStyle.textSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                  // color: context.colorExt.primary,
                                ),
                              ),
                              TextSpan(
                                text: context.l.enterOtp,
                                style: context.appTextStyle.textSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    50.ph,
                    PinPutWidget(
                      pinCodeController: provider.otpControler,
                      onCompleted: (pin) {},
                      validator: (value) {
                        return null;
                      },
                    ),
                    30.ph,

                    GradientButton(
                      title: context.l.bVerify,
                      showLoading: provider.isLoading,
                      disabled: !provider.canVerify,
                      onTap: () => verify(context, ref),
                    ),
                    20.ph,
                    ResendTimer(pinCodeController: provider.otpControler),

                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontFamily: 'Arial', // Change as needed
                            ),
                            children: [
                              TextSpan(text: context.l.acceptOur),
                              TextSpan(
                                text: context.l.termOfPolicy,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: context.l.andOur),
                              TextSpan(
                                text: context.l.privacyPolicy,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    20.ph,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
