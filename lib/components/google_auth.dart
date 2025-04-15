import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key, this.isLogin = false});
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorExt.border, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/svgs/ic_google.svg", height: 40),
          Text(
            '${isLogin ? "Log in" : "Sign up"} with Google',
            style: AppTextStyle(context).textSmall,
          ),
        ],
      ),
    );
  }
}
