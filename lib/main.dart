import 'package:bmi_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/theme_provider.dart';
import 'core/prefs/shared_prefs_provider.dart';
import 'core/router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: const BMICalculatorApp(),
    ),
  );
}

class BMICalculatorApp extends ConsumerWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appThemeModeProvider);
    return MaterialApp.router(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getThemeData(AppThemeMode.light),
      darkTheme: AppTheme.getThemeData(AppThemeMode.dark),
      themeMode: mode == AppThemeMode.dark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
