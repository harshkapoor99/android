import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final List<AssetGenImage> images = [
    Assets.images.bgGrad,
    Assets.images.bgImg,
    Assets.images.bgGradLarge,
    Assets.images.bgGradSmall,
    Assets.images.imgTrans1,
    Assets.images.imgTrans2,
    Assets.images.onboarding.obImg1,
    Assets.images.onboarding.obImg2,
    Assets.images.onboarding.obImg3,
    Assets.images.onboarding.obImg4,
    Assets.images.onboarding.obImg5,
    Assets.images.onboarding.obImg6,
    Assets.images.onboarding.obImg7,
    Assets.images.onboarding.obImg8,
    Assets.images.onboarding.obImg9,
    Assets.images.onboarding.obImg10,
    Assets.images.onboarding.obImg11,
    Assets.images.onboarding.obImg12,
  ];

  // @override
  // void initState() {
  //   ref.read(hiveServiceProvider.notifier).removeAllData();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    final precacheFutures =
        images
            .map((image) => precacheImage(image.provider(), context))
            .toList();
    // Adjust the provider based on the image type
    Future.wait(precacheFutures).then((value) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        final hiveService = ref.read(hiveServiceProvider.notifier);
        final isOnboarded = hiveService.getOnboardingStatus();
        final userInfo = hiveService.getUserInfo();

        if (!isOnboarded) {
          context.nav.pushReplacementNamed(Routes.onboarding);
        } else if (userInfo == null) {
          context.nav.pushReplacementNamed(Routes.login);
        } else {
          context.nav.pushReplacementNamed(Routes.dashboard);
        }
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset(Assets.images.logoAnimation)),
    );
  }
}
