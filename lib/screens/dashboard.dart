import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/screens/tabs/chat.dart';
import 'package:guftagu_mobile/screens/tabs/create.dart';
import 'package:guftagu_mobile/screens/tabs/myAis.dart';
import 'package:guftagu_mobile/screens/tabs/profile.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    ChatTab(),
    CreateTab(),
    MyAisTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorExt.background,
      appBar: AppConstants.appbar(context),
      body: _screens[_currentIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF171717),
        selectedItemColor: context.colorExt.textPrimary,
        unselectedItemColor: Colors.grey,
        onTap:
            (index) => setState(() {
              _currentIndex = index;
            }),
        items:
            [
                  BottomBarIconLabel(
                    assetName: Assets.svgs.icChat,
                    label: 'Chat',
                  ),
                  BottomBarIconLabel(
                    assetName: Assets.svgs.icCreate,
                    label: 'Create',
                  ),
                  BottomBarIconLabel(
                    assetName: Assets.svgs.icMyAi,
                    label: 'My AIs',
                  ),
                  BottomBarIconLabel(
                    assetName: Assets.svgs.icProfile,
                    label: 'Profile',
                  ),
                ]
                .map(
                  (BottomBarIconLabel iconLabel) => BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(
                      iconLabel.assetName,
                      height: 18.w,
                      width: 18.w,
                      colorFilter: ColorFilter.mode(
                        context.colorExt.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    icon: SvgPicture.asset(
                      iconLabel.assetName,
                      height: 18.w,
                      width: 18.w,
                      colorFilter: ColorFilter.mode(
                        context.colorExt.textPrimary.withValues(alpha: 0.6),
                        BlendMode.srcIn,
                      ),
                    ),
                    label: iconLabel.label,
                  ),
                )
                .toList(),
      ),
    );
  }
}

class BottomBarIconLabel {
  BottomBarIconLabel({required this.assetName, required this.label});
  String assetName;
  String label;
}
