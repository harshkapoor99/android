import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/components/text_input_widget.dart';
import 'package:guftagu_mobile/configs/app_color.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';

class AppConstants {
  static appbar(
    BuildContext context, {
    bool implyLeading = true,
    bool showNotificationIcon = true,
    bool showSearchIcon = true,
    bool showSearch = false,
    TextEditingController? searchController,
    required void Function() onSearchPressed,
    required void Function() onNotificationPressed,
  }) {
    // bool isDarkModeEnabled = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      // commit - implyLeading
      backgroundColor: context.colorExt.background,
      automaticallyImplyLeading: implyLeading,

      leading:
          !showSearch
              ? Consumer(
                builder: (context, ref, child) {
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(masterDataProvider.notifier)
                          .fetchMasterCharacters();
                      context.nav.pushNamed(Routes.explore);
                    },
                    child: SvgPicture.asset(
                      Assets.svgs.logo,
                      height: 50,
                      width: 50,
                    ),
                  );
                },
              )
              : null,
      leadingWidth: 70,

      titleSpacing: 0,
      title: AnimatedSwitcher(
        duration: Durations.medium4,
        child:
            showSearch
                ? Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    height: 50,
                    child: TextInputWidget(
                      controller: searchController,
                      hint: "Search you characters",
                    ),
                  ),
                )
                : Text('Guftagu', style: context.appTextStyle.appBarText),
      ),

      actionsPadding: const EdgeInsets.symmetric(horizontal: 5),
      actions: [
        if (showSearchIcon)
          !showSearch
              ? IconButton(
                onPressed: onSearchPressed,
                icon: SvgPicture.asset(
                  Assets.svgs.icSearch,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    context.colorExt.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              )
              : IconButton(
                splashColor: Colors.transparent,
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: onSearchPressed,
              ),
        if (showNotificationIcon && !showSearch)
          IconButton(
            onPressed: onNotificationPressed,
            icon: SvgPicture.asset(
              Assets.svgs.icNotification,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                context.colorExt.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
      ],
    );
  }

  static void showSnackbar({
    required String message,
    required bool isSuccess,
    bool isTop = false,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      dismissDirection:
          isTop ? DismissDirection.startToEnd : DismissDirection.down,
      backgroundColor:
          isSuccess
              ? AppStaticColors.grayColor.withValues(alpha: 1)
              : AppStaticColors.redColor.withValues(alpha: 1),
      content: Text(
        message,
        style: snackbarKey.currentContext!.appTextStyle.textSmall.copyWith(
          color:
              isSuccess
                  ? null
                  : snackbarKey.currentContext!.colorExt.background,
        ),
      ),
      margin:
          isTop
              ? EdgeInsets.only(
                bottom:
                    MediaQuery.of(
                      navigatorKey.currentState!.context,
                    ).size.height -
                    160,
                right: 20,
                left: 20,
              )
              : null,
    );
    // ScaffoldMessenger.of(
    //   navigatorKey.currentState!.context,
    // ).showSnackBar(snackBar);
    snackbarKey.currentState!.showSnackBar(snackBar);
  }

  static getPickImageAlert({
    required BuildContext context,
    required VoidCallback pressCamera,
    required VoidCallback pressGallery,
    VoidCallback? pressDocument,
    VoidCallback? pressAudio,
  }) {
    showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 640),
      backgroundColor: context.colorExt.surface,

      builder: (context) {
        return Ink(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: pressGallery,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 1),
                  child: const ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Upload from Gallery"),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),

                onTap: pressCamera,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 1),
                  child: const ListTile(
                    leading: Icon(Icons.add_a_photo),
                    title: Text("Take photo"),
                  ),
                ),
              ),
              if (pressDocument != null)
                InkWell(
                  borderRadius: BorderRadius.circular(10),

                  onTap: pressDocument,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 1),
                    child: const ListTile(
                      leading: Icon(Icons.upload_file_rounded),
                      title: Text("Upload Document"),
                    ),
                  ),
                ),
              if (pressAudio != null)
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: pressAudio,
                  child: const ListTile(
                    leading: Icon(Icons.audiotrack),
                    title: Text("Upload Audio"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static InputDecoration inputDecoration(BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: context.colorExt.surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: context.appTextStyle.text.copyWith(
          color: context.colorExt.textHint,
        ),
        suffixIconColor: context.colorExt.textPrimary,
      );

  static const playerWaveStyle = PlayerWaveStyle(
    fixedWaveColor: Colors.black,
    liveWaveColor: Colors.lightBlue,
    backgroundColor: Colors.black,
  );

  static GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
