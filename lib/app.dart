import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

import 'core/widgets/theme_toggle.dart';
import 'core/utils/responsive_layout.dart';
import 'core/services/theme_service.dart';
import 'core/widgets/welcome_section.dart';
import 'core/widgets/feature_card.dart';
import 'core/widgets/getting_started_section.dart';


class BMIHomePage extends StatefulWidget {
  const BMIHomePage({super.key});

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return HealthLayout(
      title: 'Smart BMI Calculator',
      showAppBar: true,
      actions: [
        const ThemeToggle(),
        const SizedBox(width: 8),
      ],
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            FadeInDown(
              duration: theme.mediumAnimation,
              child: const WelcomeSection(),
            ),
            
            SizedBox(height: theme.spaceLarge),
            
            // Feature Preview Cards
            FadeInUp(
              duration: theme.mediumAnimation,
              delay: const Duration(milliseconds: 200),
              child: const FeaturePreview(),
            ),
            
            SizedBox(height: theme.spaceXLarge),
            
            // Getting Started Section
            FadeInUp(
              duration: theme.mediumAnimation,
              delay: const Duration(milliseconds: 400),
              child: GettingStartedSection(
                onPrimaryPressed: () {
                  context.go('/input');
                },
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom + theme.spaceMedium),
          ],
        ),
      ),
    );
  }
}
