import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/full_screen_display/full_screen_display.dart';
import '../presentation/banner_creator/banner_creator.dart';
import '../presentation/preset_manager/preset_manager.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String splash = '/splash-screen';
  static const String fullDisplay = '/full-screen-display';
  static const String bannerCreator = '/banner-creator';
  static const String presetManager = '/preset-manager';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    splash: (context) => const SplashScreen(),
    fullDisplay: (context) => const FullScreenDisplay(),
    bannerCreator: (context) => const BannerCreator(),
    presetManager: (context) => const PresetManager(),
    // TODO: Add your other routes here
  };
}
