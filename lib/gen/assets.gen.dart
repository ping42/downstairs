/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/background.mp3
  String get background => 'assets/audio/background.mp3';

  /// File path: assets/audio/effect.mp3
  String get effect => 'assets/audio/effect.mp3';
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  AssetGenImage get background01 =>
      const AssetGenImage('assets/images/background_01.png');

  AssetGenImage get background02 =>
      const AssetGenImage('assets/images/background_02.png');

  AssetGenImage get background03 =>
      const AssetGenImage('assets/images/background_03.png');

  AssetGenImage get background04 =>
      const AssetGenImage('assets/images/background_04.png');

  AssetGenImage get background05 =>
      const AssetGenImage('assets/images/background_05.png');

  AssetGenImage get background06 =>
      const AssetGenImage('assets/images/background_06.png');

  AssetGenImage get chefIdle =>
      const AssetGenImage('assets/images/chef_idle.png');

  AssetGenImage get chefJump =>
      const AssetGenImage('assets/images/chef_jump.png');

  AssetGenImage get chefRun =>
      const AssetGenImage('assets/images/chef_run.png');

  AssetGenImage get monkeyDead =>
      const AssetGenImage('assets/images/monkey_dead.png');

  AssetGenImage get monkeyHit =>
      const AssetGenImage('assets/images/monkey_hit.png');

  AssetGenImage get monkeyIdle =>
      const AssetGenImage('assets/images/monkey_idle.png');

  AssetGenImage get monkeyJump =>
      const AssetGenImage('assets/images/monkey_jump.png');

  AssetGenImage get monkeyRun =>
      const AssetGenImage('assets/images/monkey_run.png');

  AssetGenImage get downstairsLogo =>
      const AssetGenImage('assets/images/downstairs_logo.png');

  AssetGenImage get platformNormalLong =>
      const AssetGenImage('assets/images/platform_normal_long.png');

  AssetGenImage get platformNormalShort =>
      const AssetGenImage('assets/images/platform_normal_short.png');
}

class $AssetsLicensesGen {
  const $AssetsLicensesGen();

  $AssetsLicensesPoppinsGen get poppins => const $AssetsLicensesPoppinsGen();
}

class $AssetsLicensesPoppinsGen {
  const $AssetsLicensesPoppinsGen();

  /// File path: assets/licenses/poppins/OFL.txt
  String get ofl => 'assets/licenses/poppins/OFL.txt';
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLicensesGen licenses = $AssetsLicensesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
