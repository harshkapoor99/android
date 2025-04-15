import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/components/gradient_button.dart';
import 'package:guftagu_mobile/providers/tab.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientButton(
            title: "Logout",
            onTap: () {
              ref.read(hiveServiceProvider.notifier).removeAllData();
              context.nav
                  .pushNamedAndRemoveUntil(Routes.login, (route) => false)
                  .then(
                    (value) => ref.read(tabIndexProvider.notifier).changeTab(0),
                  );
            },
          ),
        ],
      ),
    );
  }
}
