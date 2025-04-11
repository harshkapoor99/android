import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/bluring_image_cluster.dart';
import 'package:guftagu_mobile/components/google_auth.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<FocusNode> _focusNodes = [FocusNode()];
  bool isLogin = true;
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
      context.nav.pushNamed(Routes.otp);
    });
  }

  void toggleLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Assets.images.bgGrad.image(width: double.infinity),
            BluringImageCluster(focusNodes: _focusNodes),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      isLogin ? 'Log In' : 'Sign Up',
                      style: AppTextStyle(context).title,
                    ),
                  ),
                  50.ph,

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Email / Mobile no.",
                      style: AppTextStyle(context).labelText,
                    ),
                  ),
                  10.ph,
                  TextInputWidget(focusNode: _focusNodes[0]),
                  30.ph,
                  GradientButton(
                    title: "continue",
                    showLoading: isLoading,
                    onTap: login,
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
                  GoogleAuthButton(isLogin: isLogin),
                  20.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Haven't registered yet? ",
                        style: AppTextStyle(context).textSmall,
                      ),
                      GestureDetector(
                        onTap: toggleLogin,
                        // () =>
                        //     context.nav.pushReplacementNamed(Routes.signup),
                        child: Text(
                          !isLogin ? "Log in!" : "Sign up!",
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
