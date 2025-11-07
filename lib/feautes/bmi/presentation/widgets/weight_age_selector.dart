import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/input_label.dart';

/// Enhanced weight and age selector with improved UX
/// Simplified design with progress bar and larger buttons for better accessibility
class WeightAgeSelector extends ConsumerStatefulWidget {
  final double value;
  final double min;
  final double max;
  final String unit;
  final bool isInteger;
  final ValueChanged<double> onChanged;

  const WeightAgeSelector({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    this.isInteger = false,
  });

  @override
  ConsumerState<WeightAgeSelector> createState() => _WeightAgeSelectorState();
}

class _WeightAgeSelectorState extends ConsumerState<WeightAgeSelector>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _increment() {
    final step = widget.isInteger ? 1.0 : 0.5;
    final newValue = (widget.value + step).clamp(widget.min, widget.max);
    if (newValue != widget.value) {
      _triggerFeedback();
      widget.onChanged(widget.isInteger ? newValue.roundToDouble() : newValue);
    }
  }

  void _decrement() {
    final step = widget.isInteger ? 1.0 : 0.5;
    final newValue = (widget.value - step).clamp(widget.min, widget.max);
    if (newValue != widget.value) {
      _triggerFeedback();
      widget.onChanged(widget.isInteger ? newValue.roundToDouble() : newValue);
    }
  }

  void _triggerFeedback() {
    ref.read(hapticServiceProvider).light();
    _scaleController.forward().then((_) => _scaleController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final color = widget.unit == 'kg' ? theme.healthPrimary : theme.healthSecondary;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: EdgeInsets.all(theme.paddingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: theme.borderRadiusMedium,
              border: Border.all(
                color: color.withOpacity(0.2),
                width: theme.borderWidthNormal,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                InputLabel(
                  icon: widget.unit == 'kg' ? '⚖️' : '🎂',
                  label: widget.unit == 'kg' ? 'Weight' : 'Age',
                ),
                
                SizedBox(height: theme.spaceSmall),
                
                // Progress bar
                _ProgressBar(
                  value: widget.value,
                  min: widget.min,
                  max: widget.max,
                  color: color,
                  theme: theme,
                ),
                
                SizedBox(height: theme.spaceMedium),
                
                // Value display and controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CounterButton(
                      icon: Icons.remove,
                      onPressed: widget.value > widget.min ? _decrement : null,
                      color: color,
                      theme: theme,
                    ),
                    
                    // Current value with improved styling
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.paddingMedium,
                        vertical: theme.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: theme.borderRadiusMedium,
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: theme.borderWidthNormal,
                        ),
                      ),
                      child: Text(
                        widget.isInteger 
                            ? '${widget.value.toInt()}'
                            : '${widget.value.toStringAsFixed(1)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    
                    Text(
                      ' ${widget.unit}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    _CounterButton(
                      icon: Icons.add,
                      onPressed: widget.value < widget.max ? _increment : null,
                      color: color,
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Simple progress bar for visual feedback
class _ProgressBar extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color color;
  final ThemeService theme;

  const _ProgressBar({
    required this.value,
    required this.min,
    required this.max,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedValue = ((value - min) / (max - min)).clamp(0.0, 1.0);
    
    return SizedBox(
      height: 8,
      child: ClipRRect(
        borderRadius: theme.borderRadiusSmall,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.centerLeft,
                width: double.infinity * normalizedValue,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      color.withOpacity(0.8),
                      color.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Counter button with larger size for better accessibility
class _CounterButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final ThemeService theme;

  const _CounterButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.theme,
  });

  @override
  State<_CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<_CounterButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_pressController);
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: Material(
            color: Colors.transparent,
            borderRadius: widget.theme.borderRadiusMedium,
            child: InkWell(
              borderRadius: widget.theme.borderRadiusMedium,
              onTap: widget.onPressed,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.onPressed != null
                      ? widget.color.withOpacity(0.1)
                      : widget.theme.colorScheme.surfaceContainerHighest,
                  borderRadius: widget.theme.borderRadiusMedium,
                  border: Border.all(
                    color: widget.onPressed != null
                        ? widget.color.withOpacity(0.3)
                        : widget.theme.colorScheme.outlineVariant.withOpacity(0.5),
                    width: widget.theme.borderWidthNormal,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.theme.iconSizeMedium,
                  color: widget.onPressed != null
                      ? widget.color
                      : widget.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}