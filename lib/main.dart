import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_banner_display/presentation/full_screen_display/full_screen_display.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'led_banner_display',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        // Remove 'routes' here to avoid conflicts
        initialRoute: AppRoutes.initial,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.fullDisplay:
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (context) => FullScreenDisplay(
                  bannerConfig: args,
                ),
                settings: settings,
              );
            // Add other named routes if you want
            default:
              final builder = AppRoutes.routes[settings.name];
              if (builder != null) {
                return MaterialPageRoute(
                  builder: builder,
                  settings: settings,
                );
              }
              return null;
          }
        },
      );
    });
  }
}
