import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/auth_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class GoogleAuthButton extends ConsumerWidget {
  const GoogleAuthButton({super.key, this.isLogin = false});
  final bool isLogin;

  void _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    ref.read(authProvider.notifier).googleAuth().then((value) {
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
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(authProvider);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap:
            provider.isGoogleAuthLoading
                ? null
                : () => _handleGoogleSignIn(context, ref),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: context.colorExt.surface, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (provider.isGoogleAuthLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                SvgPicture.asset(Assets.svgs.icGoogle, height: 40),
              const SizedBox(width: 12),
              Text(
                provider.isGoogleAuthLoading
                    ? 'Signing in...'
                    : '${isLogin ? "Log in" : "Sign up"} with Google',
                style: AppTextStyle(context).textSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
