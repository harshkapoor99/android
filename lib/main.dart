import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guftagu_mobile/configs/hive_contants.dart';
import 'package:guftagu_mobile/configs/theme.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppHSC.authBox);
  await Hive.openBox(AppHSC.userBox);
  await Hive.openBox(AppHSC.appSettingsBox);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppConstants.navigatorKey,
      scaffoldMessengerKey: AppConstants.snackbarKey,
      title: 'Guftagu',
      // themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      themeMode: ThemeMode.dark,
      theme: getAppTheme(context: context, isDarkTheme: false),
      darkTheme: getAppTheme(context: context, isDarkTheme: true),
      onGenerateRoute: Routes.generatedRoutes,
      initialRoute: Routes.splash,
    );
  }
}
