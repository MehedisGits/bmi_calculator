import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/theme_service.dart';

/// Getting started section widget for the BMI Calculator
/// Displays a call-to-action section with primary action button
class GettingStartedSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? description;
  final String? buttonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final IconData? icon;

  const GettingStartedSection({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.buttonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Ready to Begin?',
          style: theme.headingText?.copyWith(
            color: theme.healthOnSurface,
          ),
        ),
        SizedBox(height: theme.spaceMedium),
        
        Container(
          width: double.infinity,
          padding: theme.cardPadding,
          decoration: BoxDecoration(
            color: theme.healthSurface,
            borderRadius: theme.cardRadius,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon ?? Icons.calculate_outlined,
                size: 48,
                color: theme.healthPrimary,
              ),
              SizedBox(height: theme.spaceMedium),
              Text(
                subtitle ?? 'Calculate Your BMI',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.healthOnSurface,
                ),
              ),
              SizedBox(height: theme.spaceSmall),
              Text(
                description ?? 'Enter your height, weight, and age to get started with your personalized health analysis.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.healthOnSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
              SizedBox(height: theme.spaceLarge),
              
              // Primary Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPrimaryPressed ?? () => _defaultPrimaryAction(context),
                  style: theme.primaryButtonStyle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: theme.paddingSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded),
                        SizedBox(width: theme.spaceSmall),
                        Text(
                          buttonText ?? 'Start Health Analysis',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: theme.spaceMedium),
              
              // Secondary Action Button
              TextButton.icon(
                onPressed: onSecondaryPressed ?? () => _defaultSecondaryAction(context),
                icon: const Icon(Icons.info_outline),
                label: Text(secondaryButtonText ?? 'Learn More'),
                style: theme.subtleButtonStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _defaultPrimaryAction(BuildContext context) {
    context.push('/bmi');
  }

  void _defaultSecondaryAction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About BMI Calculation'),
        content: const Text(
          'Body Mass Index (BMI) is a measure of body fat based on height and weight. Our intelligent system provides personalized insights based on your age, gender, and lifestyle factors.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
