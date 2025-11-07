import 'package:flutter/material.dart';
import '../services/theme_service.dart';

/// Unified input label component for consistent labeling across all inputs
/// Replaces duplicate _InputLabel, _CounterLabel, _HeightLabel implementations
class InputLabel extends StatelessWidget {
  final String icon;
  final String label;
  final String? value;
  final Color? iconColor;
  final Color? labelColor;
  final TextStyle? textStyle;

  const InputLabel({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.iconColor,
    this.labelColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;

    return Row(
      children: [
        Text(
          icon,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        SizedBox(width: theme.spaceXS),
        Text(
          label,
          style: textStyle ??
              theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: labelColor ?? theme.colorScheme.onSurface,
                letterSpacing: -0.1,
              ),
        ),
        if (value != null) ...[
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.paddingSmall,
              vertical: theme.paddingXS,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.healthPrimary.withOpacity(0.1),
                  theme.healthSecondary.withOpacity(0.1),
                ],
              ),
              borderRadius: theme.borderRadiusSmall,
            ),
            child: Text(
              value!,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.healthPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

