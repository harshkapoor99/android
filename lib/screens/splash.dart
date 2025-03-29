import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    // Adjust the provider based on the image type
    Future.wait([
      precacheImage(Assets.images.bgGrad.provider(), context),
      precacheImage(Assets.images.bgGrad.provider(), context),
    ]).then((value) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        context.nav.pushReplacementNamed(Routes.dashboard);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        // Lottie.asset(Assets.images.logoAnimation),
        SvgPicture.asset(Assets.svgs.logo, width: 240.w, fit: BoxFit.contain),
      ),
    );
  }
}
