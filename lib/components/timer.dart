import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/providers/auth_provider.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class ResendTimer extends ConsumerStatefulWidget {
  const ResendTimer({super.key, required this.pinCodeController});
  final TextEditingController pinCodeController;

  @override
  ConsumerState<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends ConsumerState<ResendTimer> {
  final timeCounter = StateProvider<int>((ref) {
    return 60;
  });
  final isResendOtp = StateProvider<bool>((ref) {
    return false;
  });

  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (ref.read(timeCounter) == 0) {
        timer.cancel();
      } else {
        ref.read(timeCounter.notifier).state--;
      }
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  resendOtpRequest() async {
    ref.read(isResendOtp.notifier).state = true;
    await ref.read(authProvider.notifier).login().then((value) {
      if (value.isSuccess) {
        ref.read(authProvider).otpControler.clear();
        ref.read(isResendOtp.notifier).state = false;
        ref.read(timeCounter.notifier).state = 60;
        startTimer();
      }
      AppConstants.showSnackbar(message: value.message, isSuccess: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(timeCounter) == 0
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn’t recieve a code? ",
              style: context.appTextStyle.textSmall,
            ),
            GestureDetector(
              onTap: () {},
              child:
                  ref.watch(isResendOtp)
                      ? Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.colorExt.primary,
                            ),
                          ),
                        ),
                      )
                      : GestureDetector(
                        onTap: () {
                          resendOtpRequest();
                        },
                        child: Text(
                          "Resend SMS",
                          style: context.appTextStyle.textSmall.copyWith(
                            color: context.colorExt.primary,
                          ),
                        ),
                      ),
            ),
          ],
        )
        : Center(
          child: Text(
            "You can resend with in 00:${ref.watch(timeCounter)} seconds",
            style: context.appTextStyle.textSmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        );
  }
}
