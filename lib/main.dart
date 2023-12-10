import 'package:flutter/material.dart';
import 'package:todolistapp/auth/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color customColor = Color(0xFFBF4D4A);
  static const MaterialColor customMaterialColor = MaterialColor(
    _customColorValue,
    <int, Color>{
      50: customColor,
      100: customColor,
      200: customColor,
      300: customColor,
      400: customColor,
      500: customColor,
      600: customColor,
      700: customColor,
      800: customColor,
      900: customColor,
    },
  );

  static const int _customColorValue = 0xFFBF4D4A;

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter();
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner:
          false, // Set this to false to hide the debug banner
    );
  }
}
