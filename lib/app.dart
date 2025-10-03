import 'package:flutter/material.dart';

import 'core/widgets/theme_toggle.dart';

enum Gender { male, female }

class BMIHomePage extends StatefulWidget {
  const BMIHomePage({super.key});

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI Calculator',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          // Theme toggle button
          const ThemeToggle(),
        ],
      ),
    );
  }
}
