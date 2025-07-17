import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/profile_tile.dart';
import 'package:guftagu_mobile/configs/hive_contants.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/gen/l10n/app_localizations.gen.dart';
import 'package:guftagu_mobile/models/user_model.dart';
import 'package:guftagu_mobile/providers/chat_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/get_locale_name.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  bool isSwitched = false;

  final GlobalKey _menuKey = GlobalKey();

  void _openPopupMenu() {
    dynamic state = _menuKey.currentState;
    if (state is PopupMenuButtonState) {
      state.showButtonMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width / 2;
    String language = Hive.box(
      AppHSC.appSettingsBox,
    ).get(AppHSC.appLocal, defaultValue: 'en');
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.userBox).listenable(),
              builder: (context, user, _) {
                final Map<dynamic, dynamic> userData =
                    user.get(AppHSC.userInfo) ?? {};
                User? userInfo = User.fromMap(userData.cast<String, dynamic>());

                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: SizedBox(
                        height: 126,
                        width: 126,
                        child: NetworkImageWithPlaceholder(
                          imageUrl: userInfo.profile.profilePicture ?? "",
                          placeholder: SvgPicture.asset(
                            Assets.svgs.icProfilePlaceholder,
                          ),
                          fit: BoxFit.cover,
                          errorWidget: SvgPicture.asset(
                            Assets.svgs.icProfilePlaceholder,
                          ),
                        ),
                      ),
                    ),
                    12.ph,
                    Text(
                      userInfo.profile.fullName ?? "",
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
                  ],
                );
              },
            ),

            24.ph,

            // All menu items
            ProfileTile(
              onTap: () {
                context.nav.pushNamed(Routes.userProfile);
              },
              icon: 'assets/icons/profile01.svg',
              title: context.l.profileSettings,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.colorExt.textPrimary,
              ),
            ),
            ProfileTile(
              icon: 'assets/icons/profile02.svg',
              title: context.l.profileNotification,
              trailing: Switch(
                value: isSwitched,
                onChanged: (val) {
                  // setState(() {
                  //   isSwitched = val;
                  // });
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
            PopupMenuButton(
              key: _menuKey,
              position: PopupMenuPosition.over,
              offset: const Offset(1, 25),
              color: context.colorExt.surface,
              itemBuilder:
                  (context) =>
                      AppLocalizations.supportedLocales
                          .map(
                            (e) => PopupMenuItem(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              value: e.languageCode,
                              child: Text(getLocaleName(e.languageCode)),
                            ),
                          )
                          .toList(),
              child: ProfileTile(
                icon: 'assets/icons/profile03.svg',
                title: context.l.profileLanguage,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getLocaleName(language),
                      style: context.appTextStyle.textSmall,
                    ),
                    8.pw,
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: context.colorExt.textPrimary,
                    ),
                  ],
                ),
                onTap: _openPopupMenu,
              ),
              onSelected: (value) {
                Hive.box(AppHSC.appSettingsBox).put(AppHSC.appLocal, value);
              },
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
              builder: (context, appSettingsBox, child) {
                bool isDark = appSettingsBox.get(
                  AppHSC.isDarkTheme,
                  defaultValue: true,
                );
                return ProfileTile(
                  icon: 'assets/icons/profile04.svg',
                  title: context.l.profileTheme,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorExt.surface,
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
                          colorFilter: ColorFilter.mode(
                            !isDark
                                ? context.colorExt.tertiary
                                : context.colorExt.textHint,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 31),
                        SvgPicture.asset(
                          'assets/svgs/lucide_moon.svg',
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            isDark
                                ? context.colorExt.tertiary
                                : context.colorExt.textHint,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    bool isDark = Hive.box(
                      AppHSC.appSettingsBox,
                    ).get(AppHSC.isDarkTheme, defaultValue: true);
                    Hive.box(
                      AppHSC.appSettingsBox,
                    ).put(AppHSC.isDarkTheme, !isDark);
                  },
                );
              },
            ),
            ProfileTile(
              icon: 'assets/icons/profile05.svg',
              title: context.l.profileHelp,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.colorExt.textPrimary,
              ),
            ),
            ProfileTile(
              icon: 'assets/icons/profile06.svg',
              title: context.l.profileRefer,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.colorExt.textPrimary,
              ),
              // onTap: () => context.nav.pushNamed(Routes.audioWave),
            ),
            ProfileTile(
              // REMOVE: after subscription module added
              // onTap: () {
              //   context.nav.pushNamed(Routes.subscription);
              // },
              icon: 'assets/icons/profile07.svg',
              title: context.l.profileSubscription,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.colorExt.textPrimary,
              ),
            ),

            ProfileTile(
              icon: 'assets/icons/profile08.svg',
              title: context.l.profileLogout,
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.colorExt.textPrimary,
              ),
              onTap: () {
                ref.read(hiveServiceProvider.notifier).removeAllData();
                ref.read(chatProvider.notifier).clearChatList();
                context.nav.pushNamedAndRemoveUntil(
                  Routes.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
