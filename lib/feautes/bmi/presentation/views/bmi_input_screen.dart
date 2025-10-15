import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../widgets/bmi_input_form.dart';
import '../widgets/bmi_help_button.dart';
import '../widgets/bmi_error_display.dart';

/// Optimized BMI Input Screen with modular architecture
/// Follows single responsibility principle and clean architecture
class BMIInputScreen extends ConsumerWidget {
  const BMIInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ContextNavigationService(context);
    
    return HealthLayout(
      title: 'Health Assessment',
      actions: const [BMIHelpButton()],
      child: BMIInputScreenContent(
        onNavigateToResult: navigation.navigateToResult,
      ),
    );
  }
}

/// Main content of the BMI input screen
class BMIInputScreenContent extends ConsumerWidget {
  final VoidCallback onNavigateToResult;
  
  const BMIInputScreenContent({
    super.key,
    required this.onNavigateToResult,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: FadeInDown(
            duration: theme.mediumAnimation,
            child: BMIInputHeader(),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: theme.spaceLarge)),

        // Error Display (if any)
        const SliverToBoxAdapter(
          child: BMIErrorDisplay(),
        ),

        // Input Form
        SliverToBoxAdapter(
          child: BMIInputForm(
            onNavigateToResult: onNavigateToResult,
          ),
        ),

        // Bottom Padding
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + theme.spaceLarge,
          ),
        ),
      ],
    );
  }
}

/// Header section for BMI input screen
class BMIInputHeader extends ConsumerWidget {
  const BMIInputHeader({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Container(
      padding: theme.cardPadding,
      margin: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.healthPrimary.withOpacity(0.1),
            theme.healthSecondary.withOpacity(0.05),
          ],
        ),
        borderRadius: theme.cardRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.healthPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.health_and_safety,
              color: theme.healthPrimary,
              size: 24,
            ),
          ),
          SizedBox(width: theme.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Assessment',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.healthOnSurface,
                  ),
                ),
                SizedBox(height: theme.spaceXS),
                Text(
                  'Enter your details for personalized insights',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.healthOnSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
