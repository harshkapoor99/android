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
            } else {
              context.nav.pushReplacementNamed(Routes.interest);
            }
            ref.read(authProvider.notifier).clearControllers();
          }
          AppConstants.showSnackbar(message: value.message, isSuccess: true);
        })
        .onError((error, stackTrace) {
          AppConstants.showSnackbar(message: error.toString(), isSuccess: true);
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(authProvider);
    return Scaffold(
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
                      'OTP Verify',
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
                                  "We've sent a one-time password (OTP) to your ${provider.isEmail ? "email" : "phonenumber"} ",
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
                              text: ". Please enter it below to continue.",
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
                    title: "verify",
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
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontFamily: 'Arial', // Change as needed
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "By continuing you're indicating that you accept\nour ",
                            ),
                            TextSpan(
                              text: "Terms of Use",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: " and our "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
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
    );
  }
}
