import 'package:flutter/widgets.dart';
import 'package:guftagu_mobile/screens/auth/interest.dart';
import 'package:guftagu_mobile/screens/auth/login.dart';
import 'package:guftagu_mobile/screens/auth/otp.dart';
import 'package:guftagu_mobile/screens/auth/signup.dart';
import 'package:guftagu_mobile/screens/chat/call_screen.dart';
import 'package:guftagu_mobile/screens/chat/chat_screen.dart';
import 'package:guftagu_mobile/screens/dashboard.dart';
import 'package:guftagu_mobile/screens/splash.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();

  static const splash = "/";
  static const signup = "/signup";
  static const login = "/login";
  static const otp = "/otp";
  static const interest = "/interest";
  static const dashboard = "/dashboard";
  static const chat = "/chat";
  static const call = "/call";

  static Route generatedRoutes(RouteSettings settings) {
    Widget child;

    switch (settings.name) {
      case Routes.splash:
        child = SplashScreen();
      case Routes.signup:
        child = SignUpScreen();
      case Routes.login:
        child = LoginScreen();
      case Routes.otp:
        child = OtpScreen();
      case Routes.interest:
        child = CharacterSelectionScreen();
      case Routes.dashboard:
        child = DashboardScreen();
      case Routes.chat:
        child = ChatScreen();
      case Routes.call:
        child = CallScreen();
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
    debugPrint('Route: ${settings.name}');

    return PageTransition(
      child: child,
      type: PageTransitionType.theme,
      alignment: Alignment.center,
      settings: settings,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );
  }
}
