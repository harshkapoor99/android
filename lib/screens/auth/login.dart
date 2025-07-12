import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/components/bluring_image_cluster.dart';
import 'package:guftagu_mobile/components/google_auth.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/auth_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final List<FocusNode> _focusNodes = [FocusNode()];
  bool isLogin = true;

  // form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref
        .read(authProvider.notifier)
        .login()
        .then((value) {
          if (value.isSuccess) {
            AppConstants.showSnackbar(message: value.message, isSuccess: true);
            context.nav.pushNamed(Routes.otp);
          }
        })
        .onError((error, stackTrace) {
          AppConstants.showSnackbar(message: error.toString(), isSuccess: true);
        });
  }

  void toggleLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              BluringImageCluster(focusNodes: _focusNodes),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
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
                      TextInputWidget(
                        prefixText: provider.isEmail ? null : "+91",
                        focusNode: _focusNodes[0],
                        controller: provider.credentialControler,
                        validator: EmailOrPhoneValidator.validate,
                      ),
                      30.ph,
                      GradientButton(
                        title: "next",
                        showLoading: provider.isLoading,
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
                                color: context.colorExt.surface,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ),
                            Text('Or', style: AppTextStyle(context).textSmall),
                            Expanded(
                              child: Divider(
                                color: context.colorExt.surface,
                                indent: 20,
                                endIndent: 20,
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
                              style: AppTextStyle(context).textSmall.copyWith(
                                color: context.colorExt.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      20.ph,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
