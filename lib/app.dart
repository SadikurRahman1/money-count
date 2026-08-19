import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';

class MoneyCountApp extends StatelessWidget {
  const MoneyCountApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'নোট হিসাব',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xffF6F8F5),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff146C43)),
    ),
    home: const SplashScreen(),
  );
}
