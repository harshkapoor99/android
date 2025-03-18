import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/config/app_text_style.dart';
import 'package:guftagu_mobile/config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Guftagu",
              style: AppTextStyle(context).title.copyWith(fontSize: 40.sp),
            ),
            Container(
              height: 32.w,
              width: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors(context).primary, colors(context).secondary],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
