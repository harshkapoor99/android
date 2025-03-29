import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorExt.background,
      appBar: AppBar(
        backgroundColor: context.colorExt.background,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 30.w,
                color: Colors.white,
              ),
              onPressed: () {
                context.nav.pop();
              },
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: Assets.images.img1.provider()),
            10.pw,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jaan", style: context.appTextStyle.textBold),
                Row(
                  children: [
                    5.pw,
                    Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.green,
                      ),
                    ),
                    5.pw,
                    Text(
                      "Online",
                      style: context.appTextStyle.text.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(Assets.svgs.icCoins, height: 20.w),
            5.pw,
            Text(
              '1200',
              style: context.appTextStyle.textBold.copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Assets.images.bgGradLarge.image(),
            Align(
              alignment: Alignment.topRight,
              child: Assets.images.bgGradSmall.image(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  width: 250.w,
                  height: 250.w,
                  child: Stack(
                    children: [
                      //
                      SvgPicture.asset(Assets.svgs.bgCircleLarge),
                      Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(Assets.svgs.bgCircleSmall),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          maxRadius: 105.w,
                          backgroundImage: Assets.images.img1.provider(),
                        ),
                      ),
                    ],
                  ),
                ),
                20.ph,
                Text(
                  "12:36",
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
                20.ph,
                SvgPicture.asset(Assets.svgs.icAudioSpectrum, width: 150.w),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCircleButton(
                      SvgPicture.asset(Assets.svgs.icChat, width: 20.w),
                      context.colorExt.border,
                    ),
                    _buildCircleButton(
                      Icon(Icons.call_end, color: Colors.white, size: 30.w),
                      Color(0xFFFC015B),
                      size: 60.w,
                    ),
                    _buildCircleButton(
                      SvgPicture.asset(Assets.svgs.icSpeaker, width: 20.w),
                      context.colorExt.border,
                    ),
                  ],
                ),
                30.ph,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(Widget icon, Color color, {double size = 50}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: IconButton(icon: icon, onPressed: () {}),
    );
  }
}
