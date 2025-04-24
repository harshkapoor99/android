import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/user_model.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/screens/subscriptionPage.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    User? userInfo = ref.read(hiveServiceProvider.notifier).getUserInfo();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: SizedBox(
                  height: 126,
                  width: 126,
                  child: NetworkImageWithPlaceholder(
                    imageUrl: userInfo!.profile.profilePicture,
                    placeholder: SvgPicture.asset(
                      Assets.svgs.icProfile2,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF47C8FC),
                        BlendMode.srcIn,
                      ),
                    ),
                    fit: BoxFit.cover,
                    errorWidget: SvgPicture.asset(
                      Assets.svgs.icProfile2,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF47C8FC),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                userInfo.profile.fullName,
                style: context.appTextStyle.textBold.copyWith(
                  fontSize: 18,
                  // color: Color(0xFFF2F2F2),
                ),
              ),
              Opacity(
                opacity: 0.6,
                child: Text(
                  userInfo.email.hasValue
                      ? userInfo.email
                      : userInfo.mobileNumber.hasValue
                      ? userInfo.mobileNumber
                      : "",
                  style: context.appTextStyle.text.copyWith(
                    fontSize: 14,
                    height:
                        1.71, // Line height = fontSize × height = 14 × 1.71 ≈ 24
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // All menu items
              _buildTile(
                icon: 'assets/icons/profile01.svg',
                title: 'Profile setting',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              _buildTile(
                icon: 'assets/icons/profile02.svg',
                title: 'Notification',
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (val) {
                    setState(() {
                      isSwitched = val;
                    });
                  },
                  activeColor: const Color(
                    0xFF47C8FC,
                  ), // This is the thumb default color unless overridden
                  activeTrackColor: const Color(
                    0xFF111016,
                  ), // Optional: track (background line) color
                  inactiveThumbColor: const Color(0xFF47C8FC),
                  inactiveTrackColor: const Color(0xFF111016),
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                    final Set<WidgetState> states,
                  ) {
                    return const Color(0xFF111016);
                  }),
                ),
              ),
              _buildTile(
                icon: 'assets/icons/profile03.svg',
                title: 'Language',
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('English', style: TextStyle(color: Color(0xFFF2F2F2))),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              _buildTile(
                icon: 'assets/icons/profile04.svg',
                title: 'Theme',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF23222F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF47455E),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/uil_sun.svg',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 31),
                      SvgPicture.asset(
                        'assets/svgs/lucide_moon.svg',
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                ),
              ),
              _buildTile(
                icon: 'assets/icons/profile05.svg',
                title: 'Help',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              _buildTile(
                icon: 'assets/icons/profile06.svg',
                title: 'Refer a friend',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              _buildTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionPage(),
                    ),
                  );
                },
                icon: 'assets/icons/profile07.svg',
                title: 'Subscription',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),

              _buildTile(
                icon: 'assets/icons/profile08.svg',
                title: 'Log out',
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                onTap: () {
                  ref.read(hiveServiceProvider.notifier).removeAllData();
                  context.nav
                      .pushNamedAndRemoveUntil(Routes.login, (route) => false)
                      .then(
                        (value) =>
                            ref.read(tabIndexProvider.notifier).changeTab(0),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required String icon,
    required String title,
    required Widget trailing,
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF23222F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Future.delayed(Durations.short4, onTap),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 21.29,
              vertical: 10,
            ),
            child: Row(
              children: [
                SvgPicture.asset(icon, height: 40, width: 42.57),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height:
                          1.75, // line-height of 28px / font-size of 16px = 1.75
                      letterSpacing: 0, // 0px letter-spacing
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
