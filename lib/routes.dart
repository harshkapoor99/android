import 'package:flutter/widgets.dart';
import 'package:guftagu_mobile/screens/auth/interest.dart';
import 'package:guftagu_mobile/screens/auth/login.dart';
import 'package:guftagu_mobile/screens/auth/otp.dart';
import 'package:guftagu_mobile/screens/auth/name.dart';
import 'package:guftagu_mobile/screens/chat/call_screen.dart';
import 'package:guftagu_mobile/screens/chat/chat_screen.dart';
import 'package:guftagu_mobile/screens/dashboard.dart';
import 'package:guftagu_mobile/screens/explore.dart';
import 'package:guftagu_mobile/screens/onboarding.dart';
import 'package:guftagu_mobile/screens/user_profile.dart';
import 'package:guftagu_mobile/screens/splash.dart';
import 'package:guftagu_mobile/screens/avatar_profile.dart';
import 'package:guftagu_mobile/screens/subscription_page.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();

  static const splash = "/";
  static const name = "/name";
  static const onboarding = "/onboarding";
  static const login = "/login";
  static const otp = "/otp";
  static const interest = "/interest";
  static const dashboard = "/dashboard";
  static const explore = "/explore";
  static const chat = "/chat";
  static const characterProfile = "/characterProfile";
  static const call = "/call";
  static const profileSettings = "/profileSettings";
  static const subscription = "/subscription";

  static Route generatedRoutes(RouteSettings settings) {
    Widget child;

    switch (settings.name) {
      case Routes.splash:
        child = const SplashScreen();
      case Routes.onboarding:
        child = const Onboarding();
      case Routes.name:
        child = const NameScreen();
      case Routes.login:
        child = const LoginScreen();
      case Routes.otp:
        child = const OtpScreen();
      case Routes.interest:
        child = const CharacterSelectionScreen();
      case Routes.dashboard:
        child = DashboardScreen();
      case Routes.explore:
        child = const ExploreScreen();
      case Routes.chat:
        child = ChatScreen();
      case Routes.characterProfile:
        child = const CharacterProfile();
      case Routes.call:
        child = const CallScreen();
      case Routes.profileSettings:
        child = ProfileSettingsPage();
      case Routes.subscription:
        child = const SubscriptionScreen();
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
