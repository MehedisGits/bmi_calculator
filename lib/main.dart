import 'package:bmi_calculator/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BMICalculatorApp()));
}

class BMICalculatorApp extends ConsumerWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: ref.watch(appThemeModeProvider) == AppThemeMode.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const BMIHomePage(),
    );
  }
}
