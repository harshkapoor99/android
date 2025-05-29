import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/screens/tabs/chat.dart';
import 'package:guftagu_mobile/screens/tabs/create.dart';
import 'package:guftagu_mobile/screens/tabs/my_ais.dart';
import 'package:guftagu_mobile/screens/tabs/profile.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class DashboardScreen extends ConsumerWidget {
  DashboardScreen({super.key});

  final List<Widget> _screens = [
    const ChatTab(),
    const CreateTab(),
    const MyAisTab(),
    const ProfileTab(),
  ];

  final List<BottomBarIconLabel> _tabWidgets = [
    BottomBarIconLabel(assetName: Assets.svgs.icChat, label: 'Chat'),
    BottomBarIconLabel(assetName: Assets.svgs.icCreate, label: 'Create'),
    BottomBarIconLabel(assetName: Assets.svgs.icMyAi, label: 'My AIs'),
    BottomBarIconLabel(assetName: Assets.svgs.icProfile, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentIndex = ref.watch(tabIndexProvider);

    return PopScope(
      canPop: ref.read(tabIndexProvider) == 0,
      onPopInvokedWithResult: (bool didPop, result) {
        final currentTab = ref.read(tabIndexProvider);
        if (!didPop) {
          if (currentTab != 0) {
            ref.read(tabIndexProvider.notifier).changeTab(0);
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.colorExt.background,
        appBar: AppConstants.appbar(context),
        body: IndexedStack(
          index: ref.watch(tabIndexProvider),
          children: _screens,
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          backgroundColor: context.colorExt.background,
          selectedItemColor: context.colorExt.textPrimary,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          onTap:
              (index) => ref.read(tabIndexProvider.notifier).changeTab(index),
          items:
              _tabWidgets
                  .map(
                    (BottomBarIconLabel iconLabel) => BottomNavigationBarItem(
                      activeIcon: SvgPicture.asset(
                        iconLabel.assetName,
                        height: 18,
                        width: 18,
                        colorFilter: ColorFilter.mode(
                          context.colorExt.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        iconLabel.assetName,
                        height: 18,
                        width: 18,
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
      ),
    );
  }
}

class BottomBarIconLabel {
  BottomBarIconLabel({required this.assetName, required this.label});
  String assetName;
  String label;
}
