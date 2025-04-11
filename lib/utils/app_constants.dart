import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class AppConstants {
  static appbar(BuildContext context, {bool implyLeading = true}) {
    return AppBar(
      // commit - implyLeading
      automaticallyImplyLeading: implyLeading,
      title: Row(
        children: [
          SvgPicture.asset(Assets.svgs.logo, height: 50.w, width: 50.w),
          5.pw,
          Text('Guftagu', style: AppTextStyle(context).appBarText),
          Spacer(),
          SvgPicture.asset(Assets.svgs.icCoins, height: 20.w),
          Text(
            '1200',
            style: AppTextStyle(context).textBold.copyWith(fontSize: 12.sp),
          ),
          15.pw,
          SvgPicture.asset(
            Assets.svgs.icNotification,
            height: 20.w,
            width: 20.w,
          ),
          15.pw,
          SvgPicture.asset(Assets.svgs.icMenu, height: 20.w, width: 20.w),
        ],
      ),
    );
  }
}
