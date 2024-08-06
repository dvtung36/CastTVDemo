import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  AppAssets._();

  static String trafficSignDir = '';

  // Base
  static const String _baseImg = 'assets/images';
  static const String _baseIcon = 'assets/icons';

  // Images
  static const String logo = '$_baseImg/logo.svg';

  // Icons
  static const String icHome = '$_baseIcon/home.png';
  static const String icHomeActive = '$_baseIcon/home_active.png';
  static const String icStatistics = '$_baseIcon/statistics.png';
  static const String icStatisticsActive = '$_baseIcon/statistics_active.png';
  static const String icSettings = '$_baseIcon/settings.png';
  static const String icSettingsActive = '$_baseIcon/settings_active.png';

  static Future<void> _precachePicture(String assetName) async {
    final loader = SvgAssetLoader(assetName);
    await svg.cache
        .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }

  static Future precacheAssets(BuildContext context) async {
    await Future.wait([
      // Images
      _precachePicture(AppAssets.logo),
      // precacheImage(const AssetImage(AppAssets.intro1), context),

      // Icons
      precacheImage(const AssetImage(AppAssets.icHome), context),
      precacheImage(const AssetImage(AppAssets.icHomeActive), context),
      precacheImage(const AssetImage(AppAssets.icStatistics), context),
      precacheImage(const AssetImage(AppAssets.icStatisticsActive), context),
      precacheImage(const AssetImage(AppAssets.icSettings), context),
      precacheImage(const AssetImage(AppAssets.icSettingsActive), context),
    ]);
  }
}
