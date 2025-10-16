import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../providers/bmi_input_provider.dart';

/// Error display widget for BMI input validation
class BMIErrorDisplay extends ConsumerWidget {
  const BMIErrorDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(bmiInputErrorProvider);
    
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    final theme = context.themeService;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
      padding: theme.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: theme.cardRadius,
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: theme.colorScheme.error,
            size: 20,
          ),
          SizedBox(width: theme.spaceSmall),
          Expanded(
            child: Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            onPressed: () => ref.read(bmiInputProvider.notifier).clearError(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.error,
              size: 18,
            ),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
