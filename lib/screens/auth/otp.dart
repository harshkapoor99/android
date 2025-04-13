import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/back_button.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/pin_put.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/auth_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

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
            AppConstants.showSnackbar(message: value.message, isSuccess: true);
            context.nav.pushReplacementNamed(Routes.interest);
          }
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
            if (context.nav.canPop()) BackButtonWidget(),

            // if (context.nav.canPop()) BackButtonWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),

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
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Lorem ipsum dolor sit amet consectetur. Non morbi suscipit lectus eu. Hendrerit nunc nulla adipiscing .',
                        textAlign: TextAlign.center,
                        style: AppTextStyle(context).textSmall,
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
                    title: "confirm",
                    showLoading: provider.isLoading,
                    disabled: !provider.canVerify,
                    onTap: () => verify(context, ref),
                  ),
                  20.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn’t recieve a code? ",
                        style: AppTextStyle(context).textSmall,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Resend SMS",
                          style: AppTextStyle(
                            context,
                          ).textSmall.copyWith(color: context.colorExt.primary),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontFamily: 'Arial', // Change as needed
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "By continuing you're indicating that you accept\nour ",
                            ),
                            TextSpan(
                              text: "Terms of Use",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: " and our "),
                            TextSpan(
                              text: "Privacy Policy",
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
    );
  }
}
