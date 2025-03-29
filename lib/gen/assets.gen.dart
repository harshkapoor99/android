/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bg_grad.png
  AssetGenImage get bgGrad => const AssetGenImage('assets/images/bg_grad.png');

  /// File path: assets/images/bg_img.png
  AssetGenImage get bgImg => const AssetGenImage('assets/images/bg_img.png');

  /// File path: assets/images/img1.jpeg
  AssetGenImage get img1 => const AssetGenImage('assets/images/img1.jpeg');

  /// File path: assets/images/img2.jpeg
  AssetGenImage get img2 => const AssetGenImage('assets/images/img2.jpeg');

  /// File path: assets/images/img3.jpeg
  AssetGenImage get img3 => const AssetGenImage('assets/images/img3.jpeg');

  /// File path: assets/images/img4.jpeg
  AssetGenImage get img4 => const AssetGenImage('assets/images/img4.jpeg');

  /// File path: assets/images/img5.jpeg
  AssetGenImage get img5 => const AssetGenImage('assets/images/img5.jpeg');

  /// File path: assets/images/imgTrans1.png
  AssetGenImage get imgTrans1 =>
      const AssetGenImage('assets/images/imgTrans1.png');

  /// File path: assets/images/imgTrans2.png
  AssetGenImage get imgTrans2 =>
      const AssetGenImage('assets/images/imgTrans2.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    bgGrad,
    bgImg,
    img1,
    img2,
    img3,
    img4,
    img5,
    imgTrans1,
    imgTrans2,
    logo,
  ];
}

class $AssetsSvgsGen {
  const $AssetsSvgsGen();

  /// File path: assets/svgs/bg_circle_large.svg
  String get bgCircleLarge => 'assets/svgs/bg_circle_large.svg';

  /// File path: assets/svgs/bg_circle_small.svg
  String get bgCircleSmall => 'assets/svgs/bg_circle_small.svg';

  /// File path: assets/svgs/bg_grad.svg
  String get bgGrad => 'assets/svgs/bg_grad.svg';

  /// File path: assets/svgs/bg_grad_large.svg
  String get bgGradLarge => 'assets/svgs/bg_grad_large.svg';

  /// File path: assets/svgs/bg_grad_small.svg
  String get bgGradSmall => 'assets/svgs/bg_grad_small.svg';

  /// File path: assets/svgs/ic_audio_spectrum.svg
  String get icAudioSpectrum => 'assets/svgs/ic_audio_spectrum.svg';

  /// File path: assets/svgs/ic_chat.svg
  String get icChat => 'assets/svgs/ic_chat.svg';

  /// File path: assets/svgs/ic_chatGrag1.svg
  String get icChatGrag1 => 'assets/svgs/ic_chatGrag1.svg';

  /// File path: assets/svgs/ic_coins.svg
  String get icCoins => 'assets/svgs/ic_coins.svg';

  /// File path: assets/svgs/ic_create.svg
  String get icCreate => 'assets/svgs/ic_create.svg';

  /// File path: assets/svgs/ic_google.svg
  String get icGoogle => 'assets/svgs/ic_google.svg';

  /// File path: assets/svgs/ic_menu.svg
  String get icMenu => 'assets/svgs/ic_menu.svg';

  /// File path: assets/svgs/ic_myAi.svg
  String get icMyAi => 'assets/svgs/ic_myAi.svg';

  /// File path: assets/svgs/ic_notification.svg
  String get icNotification => 'assets/svgs/ic_notification.svg';

  /// File path: assets/svgs/ic_profile.svg
  String get icProfile => 'assets/svgs/ic_profile.svg';

  /// File path: assets/svgs/ic_speaker.svg
  String get icSpeaker => 'assets/svgs/ic_speaker.svg';

  /// File path: assets/svgs/ic_speaker_grad.svg
  String get icSpeakerGrad => 'assets/svgs/ic_speaker_grad.svg';

  /// File path: assets/svgs/logo.svg
  String get logo => 'assets/svgs/logo.svg';

  /// File path: assets/svgs/logo_animated.svg
  String get logoAnimated => 'assets/svgs/logo_animated.svg';

  /// List of all assets
  List<String> get values => [
    bgCircleLarge,
    bgCircleSmall,
    bgGrad,
    bgGradLarge,
    bgGradSmall,
    icAudioSpectrum,
    icChat,
    icChatGrag1,
    icCoins,
    icCreate,
    icGoogle,
    icMenu,
    icMyAi,
    icNotification,
    icProfile,
    icSpeaker,
    icSpeakerGrad,
    logo,
    logoAnimated,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgsGen svgs = $AssetsSvgsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
