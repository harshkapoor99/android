import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guftagu_mobile/configs/theme.dart';
import 'package:guftagu_mobile/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // XD Design Sizes
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return MaterialApp(
          title: 'Guftagu',
          // remove banner - Aryan
          debugShowCheckedModeBanner: false,
          // themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          themeMode: ThemeMode.dark,
          theme: getAppTheme(context: context, isDarkTheme: false),
          darkTheme: getAppTheme(context: context, isDarkTheme: true),
          onGenerateRoute: Routes.generatedRoutes,
          initialRoute: Routes.splash,
        );
      },
    );
  }
}
