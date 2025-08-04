import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/subscription_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int selectedIndex = 2;

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.04 * (baseSize / 16.0)).clamp(
      baseSize * 0.85,
      baseSize * 1.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final provider = ref.watch(subscriptionProvider);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.images.model.modImg1.path,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter.add(const Alignment(0, 0.1)),
              ),
            ),
            Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          context.colorExt.background,
                        ],
                        stops: const [0, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.1,
                            bottom: screenHeight * 0.01,
                          ),
                          child: Text(
                            'Subscriptions',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(context, 28),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: screenHeight * 0.03),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  spacing: 16,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    provider.products.length,
                                    (index) {
                                      return Text("data");
                                    },
                                  ),
                                ),
                              ),

                              GradientButton(
                                title: "CONTINUE",
                                disabled: provider.seletedSub == null,
                                onTap: () {},
                              ),
                              SizedBox(height: screenHeight * 0.025),

                              // Footer Text
                              Text(
                                'Subscription renews automatically. You can cancel anytime',
                                style: TextStyle(
                                  color: const Color(0xffa3a3a3),
                                  fontSize: _getResponsiveFontSize(context, 12),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              // Links Row (using Wrap)
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8.0,
                                runSpacing: 0.0,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      foregroundColor: const Color(0xffa3a3a3),
                                    ),
                                    child: Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: _getResponsiveFontSize(
                                          context,
                                          13,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: _getResponsiveFontSize(context, 12),
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      foregroundColor: const Color(0xffa3a3a3),
                                    ),
                                    child: Text(
                                      'Term and Condition',
                                      style: TextStyle(
                                        fontSize: _getResponsiveFontSize(
                                          context,
                                          13,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: screenHeight * 0.03,
                              ), // Bottom padding
                            ],
                          ),
                        ),
                        // --- End Bottom Section Content ---
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Back button (Remains fixed due to Stack positioning)
            Positioned(
              top: 10 + MediaQuery.paddingOf(context).top,
              left: screenWidth * 0.05,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Feature tile widget
class FeatureString extends StatelessWidget {
  const FeatureString(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.sizeOf(context).height; // Define here if needed
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.004),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SvgPicture.asset(
            'assets/icons/tabler_hand-finger-right.svg', // Verify path
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          Flexible(
            child: Text(title, style: context.appTextStyle.textSemibold),
          ),
        ],
      ),
    );
  }
}
