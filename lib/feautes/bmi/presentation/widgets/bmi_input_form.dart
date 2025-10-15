import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/config/bmi_config.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../providers/enhanced_bmi_input_provider.dart';
import 'gender_selector.dart';
import 'height_slider.dart';
import 'weight_age_selector.dart';
import 'bmi_preview_card.dart';
import 'calculate_button.dart';

/// Modular BMI input form with optimized performance
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
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    _schedulePreviewDisplay();
  }

  void _schedulePreviewDisplay() {
    Future.delayed(BMIConfig.ui.previewDelayDuration, () {
      if (mounted) {
        setState(() => _showPreview = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final inputState = ref.watch(enhancedBMIInputProvider);
    
    return Column(
      children: [
        // Gender Selection
        FadeInUp(
          duration: theme.mediumAnimation,
          delay: const Duration(milliseconds: 200),
          child: BMIInputSection(
            title: 'Gender',
            icon: Icons.person_outline,
            child: GenderSelector(
              selectedGender: inputState.input.gender,
              onGenderChanged: ref.read(enhancedBMIInputProvider.notifier).updateGender,
            ),
          ),
        ),

        SizedBox(height: theme.spaceLarge),

        // Height Slider
        FadeInUp(
          duration: theme.mediumAnimation,
          delay: const Duration(milliseconds: 400),
          child: BMIInputSection(
            title: 'Height',
            icon: Icons.height,
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
          duration: theme.mediumAnimation,
          delay: const Duration(milliseconds: 600),
          child: ResponsiveRow(
            children: [
              Flexible(
                flex: 1,
                child: BMIInputSection(
                  title: 'Weight',
                  icon: Icons.fitness_center,
                  subtitle: 'kg',
                  child: WeightAgeSelector(
                    value: inputState.input.weight,
                    min: BMIConfig.weightLimits.min,
                    max: BMIConfig.weightLimits.max,
                    unit: BMIConfig.weightLimits.unit,
                    onChanged: ref.read(enhancedBMIInputProvider.notifier).updateWeight,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: BMIInputSection(
                  title: 'Age',
                  icon: Icons.cake_outlined,
                  subtitle: 'years',
                  child: WeightAgeSelector(
                    value: inputState.input.age.toDouble(),
                    min: BMIConfig.ageLimits.min,
                    max: BMIConfig.ageLimits.max,
                    unit: BMIConfig.ageLimits.unit,
                    isInteger: true,
                    onChanged: (age) => ref.read(enhancedBMIInputProvider.notifier).updateAge(age.round()),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: theme.spaceXLarge),

        // BMI Preview Card (appears after delay)
        if (_showPreview)
          FadeInUp(
            duration: theme.slowAnimation,
            child: BMIPreviewCard(
              input: inputState.input,
              onPreviewTap: widget.onNavigateToResult,
            ),
          ),

        SizedBox(height: theme.spaceXLarge),

        // Calculate Button
        FadeInUp(
          duration: theme.mediumAnimation,
          delay: Duration(milliseconds: _showPreview ? 200 : 800),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
            child: CalculateButton(
              input: inputState.input,
              onPressed: widget.onNavigateToResult,
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable input section wrapper with consistent styling
class BMIInputSection extends ConsumerWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget child;

  const BMIInputSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Container(
      padding: theme.cardPadding,
      margin: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
      decoration: BoxDecoration(
        color: theme.healthSurface,
        borderRadius: theme.cardRadius,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BMISectionHeader(
            title: title,
            icon: icon,
            subtitle: subtitle,
          ),
          SizedBox(height: theme.spaceMedium),
          child,
        ],
      ),
    );
  }
}

/// Section header with icon and title
class BMISectionHeader extends ConsumerWidget {
  final String title;
  final IconData icon;
  final String? subtitle;

  const BMISectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Row(
      children: [
        Icon(
          icon,
          color: theme.healthPrimary,
          size: 20,
        ),
        SizedBox(width: theme.spaceSmall),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.healthOnSurface,
          ),
        ),
        if (subtitle != null) ...[
          const Spacer(),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.healthOnSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
