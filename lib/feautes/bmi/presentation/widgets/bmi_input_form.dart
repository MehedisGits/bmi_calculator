import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/config/bmi_config.dart';
import '../providers/enhanced_bmi_input_provider.dart';
import 'gender_selector.dart';
import 'height_slider.dart';
import 'weight_age_selector.dart';
import 'calculate_button.dart';

/// Enhanced BMI input form with unified container design following UX strategy
/// Consolidates all inputs into a single, cohesive interface for minimal cognitive load
class BMIInputForm extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToResult;
  
  const BMIInputForm({
    super.key,
    required this.onNavigateToResult,
  });

  @override
  ConsumerState<BMIInputForm> createState() => _BMIInputFormState();
}

class _BMIInputFormState extends ConsumerState<BMIInputForm> {
  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final inputState = ref.watch(enhancedBMIInputProvider);
    
    return Column(
      children: [
        // Unified Input Container
        FadeInUp(
          duration: theme.mediumAnimation,
          child: _UnifiedInputContainer(inputState: inputState),
        ),
        
        SizedBox(height: theme.spaceLarge),

        // Enhanced Calculate Button
        FadeInUp(
          duration: theme.mediumAnimation,
          delay: Duration(milliseconds: 200),
          child: CalculateButton(
            input: inputState.input,
            onPressed: widget.onNavigateToResult,
            isLoading: inputState.hasError,
          ),
        ),
      ],
    );
  }
}

/// Unified input container that consolidates all BMI inputs into a single interface
class _UnifiedInputContainer extends ConsumerWidget {
  final BMIInputState inputState;

  const _UnifiedInputContainer({required this.inputState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
      padding: EdgeInsets.all(theme.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.healthPrimary.withOpacity(0.08),
            theme.healthSecondary.withOpacity(0.04),
            Colors.white.withOpacity(0.95),
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
        borderRadius: theme.borderRadiusMedium,
        boxShadow: [
          BoxShadow(
            color: theme.healthPrimary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          FadeInDown(
            duration: theme.fastAnimation,
            child: _SectionHeader(),
          ),
          
          SizedBox(height: theme.spaceLarge),
          
          // Gender Selection
          FadeInLeft(
            duration: theme.fastAnimation,
            delay: Duration(milliseconds: 100),
            child: GenderSelector(
              selectedGender: inputState.input.gender,
              onGenderChanged: ref.read(enhancedBMIInputProvider.notifier).updateGender,
            ),
          ),
          
          SizedBox(height: theme.spaceLarge),
          
          // Height Slider
          FadeInLeft(
            duration: theme.fastAnimation,
            delay: Duration(milliseconds: 200),
            child: _InputSection(
              title: 'Height',
              subtitle: 'Slide to adjust your height',
              child: HeightSlider(
                value: inputState.input.height,
                onChanged: ref.read(enhancedBMIInputProvider.notifier).updateHeight,
              ),
            ),
          ),
          
          SizedBox(height: theme.spaceLarge),
          
          // Weight and Age Row
          FadeInUp(
            duration: theme.fastAnimation,
            delay: Duration(milliseconds: 300),
            child: Row(
              children: [
                Expanded(
                  child: WeightAgeSelector(
                    value: inputState.input.weight,
                    min: BMIConfig.weightLimits.min,
                    max: BMIConfig.weightLimits.max,
                    unit: BMIConfig.weightLimits.unit,
                    onChanged: ref.read(enhancedBMIInputProvider.notifier).updateWeight,
                  ),
                ),
                SizedBox(width: theme.spaceMedium),
                Expanded(
                  child: WeightAgeSelector(
                    value: inputState.input.age.toDouble(),
                    min: BMIConfig.ageLimits.min,
                    max: BMIConfig.ageLimits.max,
                    unit: BMIConfig.ageLimits.unit,
                    isInteger: true,
                    onChanged: (age) => ref.read(enhancedBMIInputProvider.notifier).updateAge(age.round()),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: theme.spaceSmall),
          
          // Subtle feature hints
          FadeIn(
            duration: theme.mediumAnimation,
            delay: Duration(milliseconds: 400),
            child: _FeatureHints(),
          ),
        ],
      ),
    );
  }
}

/// Contextual section header following UX strategy messaging
class _SectionHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(theme.paddingSmall),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.healthPrimary, theme.healthSecondary],
            ),
            borderRadius: theme.borderRadiusSmall,
          ),
          child: Icon(
            Icons.insights,
            color: Colors.white,
            size: theme.iconSizeSmall,
          ),
        ),
        SizedBox(width: theme.spaceSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about you',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.healthOnSurface,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: theme.spaceXS / 2),
              Text(
                'For personalized health insights',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.healthOnSurface.withOpacity(0.7),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Reusable input section wrapper for consistent styling
class _InputSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _InputSection({
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '📏',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            ),
            SizedBox(width: theme.spaceXS),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(width: theme.spaceXS),
              Text(
                '($subtitle)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: theme.spaceSmall),
        child,
      ],
    );
  }
}

/// Subtle feature hints at the bottom of the container
class _FeatureHints extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.psychology,
          size: theme.iconSizeSmall,
          color: theme.healthPrimary.withOpacity(0.6),
        ),
        SizedBox(width: theme.spaceXS),
        Text(
          'Smart BMI',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.healthPrimary.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: theme.spaceMedium),
        Icon(
          Icons.tips_and_updates,
          size: theme.iconSizeSmall,
          color: theme.healthSecondary.withOpacity(0.6),
        ),
        SizedBox(width: theme.spaceXS),
        Text(
          'Health Tips',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.healthSecondary.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}