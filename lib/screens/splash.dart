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
  final List<AssetGenImage> images = [
    Assets.images.bgGrad,
    Assets.images.bgImg,
    Assets.images.bgGradLarge,
    Assets.images.bgGradSmall,
    Assets.images.imgTrans1,
    Assets.images.imgTrans2,
  ];

  @override
  void didChangeDependencies() {
    final precacheFutures =
        images
            .map((image) => precacheImage(image.provider(), context))
            .toList();
    // Adjust the provider based on the image type
    Future.wait(precacheFutures).then((value) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        context.nav.pushReplacementNamed(Routes.onboarding);
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
