import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/benefir_row.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/components/utility_components/animated_reveal.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/subscription_provider.dart';
import 'package:guftagu_mobile/providers/wallet_provider.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/string_formats.dart';

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
    final wallet = ref.watch(walletProvider);

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
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, context.colorExt.background],
                      stops: const [0, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        Assets.svgs.icDiamonGold,
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.01,
                          bottom: screenHeight * 0.01,
                        ),
                        child: Text(
                          context.l.profileRecharge,
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context, 28),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // List of benefits
                            BenefitRow(text: 'Unlimited Chat'),
                            BenefitRow(text: 'Unlock AI Calling'),
                            BenefitRow(text: 'Unlock Images & Videos'),
                            BenefitRow(text: 'Personalized Experience'),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            (screenHeight * 0.03).ph,
                            Row(
                              spacing: 5,
                              children: [
                                SvgPicture.asset(
                                  Assets.svgs.icDiamonGold,
                                  width: 16,
                                  height: 16,
                                ),
                                Text(
                                  "Coin Balance:",
                                  style: context.appTextStyle.subTitle,
                                ),
                                AnimatedFlipCounter(
                                  duration: const Duration(milliseconds: 500),
                                  value: wallet.coins.ceil(),
                                  textStyle: context.appTextStyle.subTitle,
                                ),
                              ],
                            ),
                            if (provider.loading)
                              const CircularProgressIndicator()
                            else if (!provider.isAvailable)
                              Text(
                                "Opps! Looks like the store provider is not available right now.",
                                style: context.appTextStyle.buttonText,
                              )
                            else
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio:
                                    (screenWidth / 2) /
                                    (screenHeight *
                                        0.18), // dynamic aspect ratio
                                children: List.generate(provider.products.length, (
                                  index,
                                ) {
                                  final product = provider.products[index];
                                  final isSelected =
                                      product == provider.seletedProduct;
                                  if (product.id != "") {
                                    return AnimatedReveal(
                                      delay: Duration(
                                        milliseconds: 500 * index,
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            ref
                                                .read(
                                                  subscriptionProvider.notifier,
                                                )
                                                .selectProduct(product);
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? context
                                                            .colorExt
                                                            .primary
                                                        : context
                                                            .colorExt
                                                            .textHint,
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  // Remove spacing property, not supported in Row
                                                  children: [
                                                    SvgPicture.asset(
                                                      Assets.svgs.icDiamonGold,
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      removeAppNameFromProductTitle(
                                                        product.title,
                                                      ),
                                                      style:
                                                          context
                                                              .appTextStyle
                                                              .textBold,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                4.ph,
                                                Text(
                                                  product.price,
                                                  style: context
                                                      .appTextStyle
                                                      .textSemibold
                                                      .copyWith(
                                                        color:
                                                            context
                                                                .colorExt
                                                                .border,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                              ),
                            // if (kDebugMode) ...[
                            //   Text(
                            //     "purchasePending: ${provider.purchasePending.toString()}",
                            //   ),
                            //   Text(
                            //     "isAvailable: ${provider.isAvailable.toString()}",
                            //   ),
                            //   Text("loading: ${provider.loading.toString()}"),
                            //   Text("products: ${provider.products.length}"),
                            // ],
                            (screenHeight * 0.03).ph,

                            GradientButton(
                              title: "CONTINUE",
                              disabled: provider.seletedProduct == null,
                              onTap:
                                  ref
                                      .read(subscriptionProvider.notifier)
                                      .purchaseProduct,
                            ),

                            (screenHeight * 0.04).ph,

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

                            (screenHeight * 0.03).ph, // Bottom padding
                          ],
                        ),
                      ),
                      // --- End Bottom Section Content ---
                    ],
                  ),
                ),
              ),
            ),

            if (provider.purchasePending)
              const Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(dismissible: false, color: Colors.grey),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
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
