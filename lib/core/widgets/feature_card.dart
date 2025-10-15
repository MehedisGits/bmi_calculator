import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Feature card widget for showcasing app capabilities
/// Displays an icon, title, and description in a card format
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final cardColor = color ?? theme.healthPrimary;

    Widget card = Container(
      padding: theme.cardPadding,
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: theme.cardRadius,
        border: Border.all(
          color: cardColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: cardColor,
          ),
          SizedBox(height: theme.spaceMedium),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.healthOnSurface,
            ),
          ),
          SizedBox(height: theme.spaceSmall),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.healthOnSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: theme.cardRadius,
        child: card,
      );
    }

    return card;
  }
}

/// Feature preview section that displays multiple feature cards
class FeaturePreview extends StatelessWidget {
  final String? title;
  final List<FeatureCardData>? customFeatures;

  const FeaturePreview({
    super.key,
    this.title,
    this.customFeatures,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final features = customFeatures ?? _defaultFeatures(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'What You\'ll Get',
          style: theme.headingText?.copyWith(
            color: theme.healthOnSurface,
          ),
        ),
        SizedBox(height: theme.spaceMedium),
        
        // First row
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: features[0].icon,
                title: features[0].title,
                description: features[0].description,
                color: features[0].color,
                onTap: features[0].onTap,
              ),
            ),
            SizedBox(width: theme.spaceMedium),
            Expanded(
              child: FeatureCard(
                icon: features[1].icon,
                title: features[1].title,
                description: features[1].description,
                color: features[1].color,
                onTap: features[1].onTap,
              ),
            ),
          ],
        ),
        
        SizedBox(height: theme.spaceMedium),
        
        // Second row
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: features[2].icon,
                title: features[2].title,
                description: features[2].description,
                color: features[2].color,
                onTap: features[2].onTap,
              ),
            ),
            SizedBox(width: theme.spaceMedium),
            Expanded(
              child: FeatureCard(
                icon: features[3].icon,
                title: features[3].title,
                description: features[3].description,
                color: features[3].color,
                onTap: features[3].onTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<FeatureCardData> _defaultFeatures(ThemeService theme) {
    return [
      FeatureCardData(
        icon: Icons.analytics_outlined,
        title: 'Smart Analysis',
        description: 'AI-powered BMI calculation with personalized insights',
        color: theme.healthPrimary,
      ),
      FeatureCardData(
        icon: Icons.health_and_safety_outlined,
        title: 'Health Tips',
        description: 'Actionable recommendations based on your profile',
        color: theme.healthSecondary,
      ),
      FeatureCardData(
        icon: Icons.trending_up_outlined,
        title: 'Progress Tracking',
        description: 'Monitor your health journey over time',
        color: theme.healthSuccess,
      ),
      FeatureCardData(
        icon: Icons.share_outlined,
        title: 'Easy Sharing',
        description: 'Share results with healthcare providers',
        color: theme.healthInfo,
      ),
    ];
  }
}

/// Data class for feature card information
class FeatureCardData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  const FeatureCardData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.onTap,
  });
}
