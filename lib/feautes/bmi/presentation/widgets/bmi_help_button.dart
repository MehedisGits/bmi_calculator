import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';

/// Help button widget for BMI input screen
class BMIHelpButton extends ConsumerWidget {
  const BMIHelpButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => _showHelpDialog(context, ref),
      icon: const Icon(Icons.help_outline),
      tooltip: 'Help & Tips',
    );
  }

  void _showHelpDialog(BuildContext context, WidgetRef ref) {
    final haptic = ref.read(hapticServiceProvider);
    haptic.selection();
    
    showDialog(
      context: context,
      builder: (context) => const BMIHelpDialog(),
    );
  }
}

/// Help dialog with BMI input tips
class BMIHelpDialog extends ConsumerWidget {
  const BMIHelpDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.healthPrimary,
          ),
          const SizedBox(width: 8),
          const Text('BMI Input Tips'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HelpTip(
            icon: '📏',
            title: 'Height',
            description: 'Measure without shoes for accuracy',
          ),
          const SizedBox(height: 12),
          _HelpTip(
            icon: '⚖️',
            title: 'Weight',
            description: 'Best measured in the morning',
          ),
          const SizedBox(height: 12),
          _HelpTip(
            icon: '🎂',
            title: 'Age',
            description: 'Used for personalized insights',
          ),
          const SizedBox(height: 12),
          _HelpTip(
            icon: '👤',
            title: 'Gender',
            description: 'Affects BMI interpretation',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

/// Individual help tip widget
class _HelpTip extends ConsumerWidget {
  final String icon;
  final String title;
  final String description;

  const _HelpTip({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.healthOnSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
