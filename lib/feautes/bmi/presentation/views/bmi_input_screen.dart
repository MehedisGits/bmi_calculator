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
      showAppBar: false,
      title: 'Your Health Snapshot',
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
    
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Compact Header
            FadeInDown(
              duration: theme.fastAnimation,
              child: _CompactHeader(),
            ),
            
            SizedBox(height: theme.spaceLarge),
      
            // Error Display (if any)
            const BMIErrorDisplay(),
      
            // Enhanced BMI Input Form
            FadeInUp(
              duration: theme.mediumAnimation,
              delay: Duration(milliseconds: 200),
              child: BMIInputForm(
                onNavigateToResult: onNavigateToResult,
              ),
            ),
            
            // Bottom padding for safe area
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + theme.spaceMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact header following UX strategy for minimal cognitive load
class _CompactHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(theme.paddingXS),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.healthPrimary, theme.healthSecondary],
                ),
                borderRadius: theme.borderRadiusSmall,
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: theme.iconSizeSmall,
              ),
            ),
            SizedBox(width: theme.spaceSmall),
            Text(
              'Quick Health Check',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.healthPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: theme.spaceXS),
        Padding(
          padding: EdgeInsets.only(left: theme.iconSizeSmall + theme.spaceSmall),
          child: Text(
            'Discover personalized health insights in seconds',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
