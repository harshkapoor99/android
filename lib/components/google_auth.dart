import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorExt.border, width: 2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/svgs/ic_google.svg", height: 40.h),
          Text('Sign Up with Google', style: AppTextStyle(context).textSmall),
        ],
      ),
    );
  }
}
