import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.onPop});
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.nav.pop();
        if (onPop != null) {
          onPop!();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 20.h,
          left: 20.w,
        ),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: context.colorExt.background.withValues(alpha: 1),
        ),
        child: Icon(Icons.chevron_left_rounded, size: 30.sp),
      ),
    );
  }
}
