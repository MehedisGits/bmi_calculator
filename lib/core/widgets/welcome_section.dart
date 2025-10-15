import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Welcome section widget for the BMI Calculator home screen
/// Displays a greeting message with health-focused branding
class WelcomeSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;

  const WelcomeSection({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Container(
      width: double.infinity,
      padding: theme.cardPadding,
      decoration: BoxDecoration(
        gradient: theme.getHealthGradient(),
        borderRadius: theme.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon ?? Icons.favorite,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: theme.spaceMedium),
          Text(
            title ?? 'Your Health Journey\nStarts Here',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: theme.spaceSmall),
          Text(
            subtitle ?? 'Get personalized BMI insights with intelligent health recommendations tailored for you.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
