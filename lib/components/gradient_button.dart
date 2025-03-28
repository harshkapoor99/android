import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.title,
    required this.onTap,
    this.showLoading = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colorExt.primary, context.colorExt.tertiary],
          begin: Alignment(-0.5, -1.5),
          end: Alignment(1.3, 1.5),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        ),
        onPressed: onTap,
        child:
            showLoading
                ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: CircularProgressIndicator(),
                )
                : Text(
                  title.toUpperCase(),
                  style: AppTextStyle(context).buttonText,
                ),
      ),
    );
  }
}
