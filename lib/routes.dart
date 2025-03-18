import 'package:flutter/widgets.dart';
import 'package:guftagu_mobile/screens/splash.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();

  static const splash = "/";
  static const login = "/login";
  static const dashboard = "/dashboard";
  static const chat = "/chat";

  static Route generatedRoutes(RouteSettings settings) {
    Widget child;

    switch (settings.name) {
      case Routes.splash:
        child = SplashScreen();
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
    debugPrint('Route: ${settings.name}');

    return PageTransition(
      child: child,
      type: PageTransitionType.fade,
      settings: settings,
      duration: const Duration(milliseconds: 0),
      reverseDuration: const Duration(milliseconds: 0),
    );
  }
}
