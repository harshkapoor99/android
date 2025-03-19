import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/bluring_image_cluster.dart';
import 'package:guftagu_mobile/components/google_auth.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _focusNodes = [FocusNode(), FocusNode()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Image.asset("assets/images/bg_grad.png", width: double.infinity),
            BluringImageCluster(focusNodes: _focusNodes),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Sign Up', style: AppTextStyle(context).title),
                  ),
                  50.ph,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Name", style: AppTextStyle(context).labelText),
                  ),
                  10.ph,
                  TextInputWidget(focusNode: _focusNodes[0]),
                  10.ph,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Email / Mobile no.",
                      style: AppTextStyle(context).labelText,
                    ),
                  ),
                  10.ph,
                  TextInputWidget(focusNode: _focusNodes[1]),
                  30.ph,
                  GradientButton(
                    title: "verify",
                    onTap: () => context.nav.pushNamed(Routes.otp),
                  ),
                  20.ph,
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: context.colorExt.border,
                            indent: 20.w,
                            endIndent: 20.w,
                          ),
                        ),
                        Text('Or', style: AppTextStyle(context).textSmall),
                        Expanded(
                          child: Divider(
                            color: context.colorExt.border,
                            indent: 20.w,
                            endIndent: 20.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.ph,
                  GoogleAuthButton(),
                  20.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already registered? ",
                        style: AppTextStyle(context).textSmall,
                      ),
                      GestureDetector(
                        onTap:
                            () =>
                                context.nav.pushReplacementNamed(Routes.login),
                        child: Text(
                          "Login!",
                          style: AppTextStyle(
                            context,
                          ).textSmall.copyWith(color: context.colorExt.primary),
                        ),
                      ),
                    ],
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
