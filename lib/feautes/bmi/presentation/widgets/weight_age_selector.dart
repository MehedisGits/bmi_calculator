import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';

/// Enhanced weight and age selector with visual dots and unified counter design
/// Provides consistent interaction pattern with micro-interactions and haptic feedback
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
  late AnimationController _dotsController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));

    _dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _dotsController.dispose();
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
    _dotsController.forward().then((_) => _dotsController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final color = widget.unit == 'kg' ? theme.healthPrimary : theme.healthSecondary;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _dotsAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: EdgeInsets.all(theme.paddingMedium),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: theme.borderRadiusMedium,
              border: Border.all(
                color: color.withOpacity(0.2 + (_dotsAnimation.value * 0.3)),
                width: 1,
              ),
              boxShadow: [
                if (_dotsAnimation.value > 0)
                  BoxShadow(
                    color: color.withOpacity(0.1 * _dotsAnimation.value),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label row
                _CounterLabel(
                  icon: widget.unit == 'kg' ? '⚖️' : '🎂',
                  label: widget.unit == 'kg' ? 'Weight' : 'Age',
                  theme: theme,
                ),
                
                SizedBox(height: theme.spaceSmall),
                
                // Visual dots representation
                _VisualDots(
                  value: widget.value,
                  min: widget.min,
                  max: widget.max,
                  color: color,
                  animation: _dotsAnimation.value,
                  theme: theme,
                ),
                
                SizedBox(height: theme.spaceSmall),
                
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
                    
                    // Current value
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.paddingSmall,
                        vertical: theme.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.1),
                            color.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: theme.borderRadiusSmall,
                      ),
                      child: Text(
                        widget.isInteger 
                            ? '${widget.value.toInt()} ${widget.unit}'
                            : '${widget.value.toStringAsFixed(1)} ${widget.unit}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
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

/// Counter label with icon and text
class _CounterLabel extends StatelessWidget {
  final String icon;
  final String label;
  final ThemeService theme;

  const _CounterLabel({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          icon,
          style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
        ),
        SizedBox(width: theme.spaceXS / 2),
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Visual dots representation following UX strategy
class _VisualDots extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final Color color;
  final double animation;
  final ThemeService theme;

  const _VisualDots({
    required this.value,
    required this.min,
    required this.max,
    required this.color,
    required this.animation,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    const dotCount = 10;
    final normalizedValue = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final activeDots = (normalizedValue * dotCount).round();
    
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dotCount, (index) {
          final isActive = index < activeDots;
          final animationOffset = (index / dotCount) * 0.2;
          final currentAnimation = (animation - animationOffset).clamp(0.0, 1.0);
          
          return AnimatedContainer(
            duration: Duration(milliseconds: 100 + (index * 20)),
            width: isActive ? (8 + (2 * currentAnimation)) : 6,
            height: isActive ? (8 + (2 * currentAnimation)) : 6,
            margin: EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isActive
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.8 + (0.2 * currentAnimation)),
                        color.withOpacity(0.6 + (0.2 * currentAnimation)),
                      ],
                    )
                  : null,
              color: isActive 
                  ? null 
                  : theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
              boxShadow: isActive && currentAnimation > 0
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4 * currentAnimation),
                        blurRadius: 4 * currentAnimation,
                        spreadRadius: 1 * currentAnimation,
                      ),
                    ]
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

/// Counter button with consistent styling
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
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
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
          child: GestureDetector(
            onTapDown: (_) => _pressController.forward(),
            onTapUp: (_) => _pressController.reverse(),
            onTapCancel: () => _pressController.reverse(),
            onTap: widget.onPressed,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: widget.onPressed != null
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withOpacity(0.1),
                          widget.color.withOpacity(0.05),
                        ],
                      )
                    : null,
                color: widget.onPressed == null
                    ? widget.theme.colorScheme.surfaceContainerHighest
                    : null,
                borderRadius: widget.theme.borderRadiusSmall,
                border: Border.all(
                  color: widget.onPressed != null
                      ? widget.color.withOpacity(0.3)
                      : widget.theme.colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                widget.icon,
                size: widget.theme.iconSizeSmall,
                color: widget.onPressed != null
                    ? widget.color
                    : widget.theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}