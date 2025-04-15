import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/configs/app_color.dart';
import 'package:guftagu_mobile/configs/app_text_style.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/entensions.dart';

class AppConstants {
  static appbar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SvgPicture.asset(Assets.svgs.logo, height: 50, width: 50),
          5.pw,
          Text('Guftagu', style: AppTextStyle(context).appBarText),
          Spacer(),
          SvgPicture.asset(Assets.svgs.icCoins, height: 20),
          Text(
            '1200',
            style: AppTextStyle(context).textBold.copyWith(fontSize: 12),
          ),
          15.pw,
          SvgPicture.asset(Assets.svgs.icNotification, height: 20, width: 20),
          15.pw,
          SvgPicture.asset(Assets.svgs.icMenu, height: 20, width: 20),
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
        style: snackbarKey.currentContext!.appTextStyle.textSmall,
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
  }) {
    showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (context) {
        return Container(
          color: context.colorExt.border,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: pressGallery,
                child: Container(
                  margin: EdgeInsets.only(bottom: 1),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: Text("Upload from Gallery"),
                  ),
                ),
              ),
              InkWell(
                onTap: pressCamera,
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: ListTile(
                    leading: const Icon(Icons.add_a_photo),
                    title: Text("Take photo"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
