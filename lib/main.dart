import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/hive_contants.dart';
import 'package:guftagu_mobile/configs/theme.dart';
import 'package:guftagu_mobile/gen/l10n/app_localizations.gen.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.appSettingsBox);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityProvider(
      child: ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.appSettingsBox).listenable(),
        builder: (context, appSettingsBox, _) {
          bool isDark = appSettingsBox.get(
            AppHSC.isDarkTheme,
            defaultValue: true,
          );
          final selectedLocal = appSettingsBox.get(AppHSC.appLocal) as String?;
          if (selectedLocal == null) {
            appSettingsBox.put(AppHSC.appLocal, 'en');
          }
          return MaterialApp(
            navigatorKey: AppConstants.navigatorKey,
            scaffoldMessengerKey: AppConstants.snackbarKey,
            title: 'Guftagu',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(selectedLocal ?? 'en'),
            localeResolutionCallback: (deviceLocal, supportedLocales) {
              if (selectedLocal == '') {
                appSettingsBox.put(AppHSC.appLocal, deviceLocal?.languageCode);
              }
              for (final locale in supportedLocales) {
                if (locale.languageCode == deviceLocal!.languageCode) {
                  return deviceLocal;
                }
              }
              return supportedLocales.first;
            },
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: getAppTheme(context: context, isDarkTheme: false),
            darkTheme: getAppTheme(context: context, isDarkTheme: true),
            onGenerateRoute: Routes.generatedRoutes,
            initialRoute: Routes.splash,
          );
        },
      ),
    );
  }
}
