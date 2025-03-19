import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/components/google_auth.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode()];
  double _blurValue = 0.0;

  @override
  void initState() {
    super.initState();
    for (var focusNode in _focusNodes) {
      focusNode.addListener(_updateBlur);
    }
  }

  void _updateBlur() {
    setState(() {
      _blurValue = _focusNodes.any((node) => node.hasFocus) ? 6.r : 0.0;
    });
  }

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.removeListener(_updateBlur);
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Image.asset("assets/images/bg_grad.png", width: double.infinity),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: _blurValue),
              duration: Duration(
                milliseconds: 300,
              ), // Adjust animation duration
              builder: (context, blur, child) {
                return ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: child,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top + 10.h,
                ),
                child: Image.asset(
                  "assets/images/bg_img.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

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
                  GradientButton(title: "verify", onTap: () {}),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
