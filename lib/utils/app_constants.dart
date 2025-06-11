import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/configs/app_color.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/extensions.dart';

class AppConstants {
  static appbar(
    BuildContext context, {
    bool implyLeading = true,
    bool showSearchIcon = true,
  }) {
    bool isDarkModeEnabled = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      // commit - implyLeading
      backgroundColor: context.colorExt.background,
      automaticallyImplyLeading: implyLeading,
      title: Row(
        children: [
          SvgPicture.asset(
            isDarkModeEnabled ? Assets.svgs.logo : Assets.svgs.logoDark,
            height: 50,
            width: 50,
          ),
          5.pw,
          Text('Guftagu', style: context.appTextStyle.appBarText),
          const Spacer(),
          // SvgPicture.asset(Assets.svgs.icDiamonGold, height: 20),
          // 5.pw,
          // Text(
          //   '1200',
          //   style: AppTextStyle(context).textBold.copyWith(fontSize: 12),
          // ),
          15.pw,
          SvgPicture.asset(
            Assets.svgs.icNotification,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              context.colorExt.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          15.pw,
          if (showSearchIcon)
            SvgPicture.asset(
              Assets.svgs.icSearch,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                context.colorExt.textPrimary,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                    leading: Icon(Icons.attach_file),
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
                      leading: Icon(Icons.insert_drive_file),
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
