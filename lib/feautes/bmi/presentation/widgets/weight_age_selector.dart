import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/theme_service.dart';

/// Interactive weight and age selector with counter-style controls
/// Provides precise input with visual feedback and micro-interactions
class WeightAgeSelector extends StatefulWidget {
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
  State<WeightAgeSelector> createState() => _WeightAgeSelectorState();
}

class _WeightAgeSelectorState extends State<WeightAgeSelector>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _colorController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;

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

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _increment() {
    final increment = widget.isInteger ? 1.0 : 0.5;
    final newValue = (widget.value + increment).clamp(widget.min, widget.max);
    
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      _triggerFeedback();
      widget.onChanged(newValue);
    }
  }

  void _decrement() {
    final decrement = widget.isInteger ? 1.0 : 0.5;
    final newValue = (widget.value - decrement).clamp(widget.min, widget.max);
    
    if (newValue != widget.value) {
      HapticFeedback.lightImpact();
      _triggerFeedback();
      widget.onChanged(newValue);
    }
  }

  void _triggerFeedback() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    _colorController.forward().then((_) {
      _colorController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: theme.healthPrimary.withOpacity(_colorAnimation.value * 0.1),
              borderRadius: theme.cardRadius,
            ),
            child: Column(
              children: [
                // Increment Button
                _CounterButton(
                  icon: Icons.add,
                  onPressed: widget.value < widget.max ? _increment : null,
                  theme: theme,
                ),

                SizedBox(height: theme.spaceMedium),

                // Value Display
                _ValueDisplay(
                  value: widget.value,
                  unit: widget.unit,
                  isInteger: widget.isInteger,
                  theme: theme,
                ),

                SizedBox(height: theme.spaceMedium),

                // Decrement Button
                _CounterButton(
                  icon: Icons.remove,
                  onPressed: widget.value > widget.min ? _decrement : null,
                  theme: theme,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Counter button with visual feedback
class _CounterButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ThemeService theme;

  const _CounterButton({
    required this.icon,
    required this.onPressed,
    required this.theme,
  });

  @override
  State<_CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<_CounterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: isEnabled ? _onTapDown : null,
            onTapUp: isEnabled ? _onTapUp : null,
            onTapCancel: isEnabled ? _onTapCancel : null,
            onTap: widget.onPressed,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isEnabled
                    ? widget.theme.healthPrimary
                    : widget.theme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: widget.theme.healthPrimary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                widget.icon,
                color: isEnabled ? Colors.white : widget.theme.colorScheme.outline,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Value display with animated transitions
class _ValueDisplay extends StatelessWidget {
  final double value;
  final String unit;
  final bool isInteger;
  final ThemeService theme;

  const _ValueDisplay({
    required this.value,
    required this.unit,
    required this.isInteger,
    required this.theme,
  });

  String get formattedValue {
    return isInteger ? value.round().toString() : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.paddingLarge,
        vertical: theme.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Animated value
          AnimatedSwitcher(
            duration: theme.fastAnimation,
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              formattedValue,
              key: ValueKey(formattedValue),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.healthPrimary,
              ),
            ),
          ),
          
          SizedBox(height: theme.spaceXS),
          
          // Unit label
          Text(
            unit,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.healthOnSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Advanced selector with gesture controls and quick increment
class AdvancedWeightAgeSelector extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final String unit;
  final bool isInteger;
  final ValueChanged<double> onChanged;

  const AdvancedWeightAgeSelector({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    this.isInteger = false,
  });

  @override
  State<AdvancedWeightAgeSelector> createState() => _AdvancedWeightAgeSelectorState();
}

class _AdvancedWeightAgeSelectorState extends State<AdvancedWeightAgeSelector> {
  late TextEditingController _textController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.isInteger 
          ? widget.value.round().toString() 
          : widget.value.toStringAsFixed(1),
    );
  }

  @override
  void didUpdateWidget(AdvancedWeightAgeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isEditing) {
      _textController.text = widget.isInteger 
          ? widget.value.round().toString() 
          : widget.value.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextSubmitted(String value) {
    final newValue = double.tryParse(value);
    if (newValue != null) {
      final clampedValue = newValue.clamp(widget.min, widget.max);
      widget.onChanged(clampedValue);
    }
    setState(() => _isEditing = false);
  }

  void _startEditing() {
    setState(() => _isEditing = true);
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Column(
      children: [
        // Quick increment buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _QuickButton(
              label: '+10',
              onPressed: () {
                final increment = widget.isInteger ? 10.0 : 10.0;
                final newValue = (widget.value + increment).clamp(widget.min, widget.max);
                if (newValue != widget.value) {
                  HapticFeedback.mediumImpact();
                  widget.onChanged(newValue);
                }
              },
              theme: theme,
            ),
            SizedBox(width: theme.spaceSmall),
            _QuickButton(
              label: '+5',
              onPressed: () {
                final increment = widget.isInteger ? 5.0 : 5.0;
                final newValue = (widget.value + increment).clamp(widget.min, widget.max);
                if (newValue != widget.value) {
                  HapticFeedback.lightImpact();
                  widget.onChanged(newValue);
                }
              },
              theme: theme,
            ),
          ],
        ),

        SizedBox(height: theme.spaceMedium),

        // Editable value display
        GestureDetector(
          onTap: _startEditing,
          child: Container(
            padding: EdgeInsets.all(theme.paddingLarge),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: theme.cardRadius,
              border: Border.all(
                color: _isEditing 
                    ? theme.healthPrimary 
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: _isEditing ? 2 : 1,
              ),
            ),
            child: _isEditing 
                ? TextField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.healthPrimary,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter ${widget.unit}',
                    ),
                    onSubmitted: _onTextSubmitted,
                    onTapOutside: (_) {
                      _onTextSubmitted(_textController.text);
                    },
                    autofocus: true,
                  )
                : Column(
                    children: [
                      Text(
                        widget.isInteger 
                            ? widget.value.round().toString()
                            : widget.value.toStringAsFixed(1),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.healthPrimary,
                        ),
                      ),
                      SizedBox(height: theme.spaceXS),
                      Text(
                        widget.unit,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.healthOnSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: theme.spaceMedium),

        // Quick decrement buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _QuickButton(
              label: '-5',
              onPressed: () {
                final decrement = widget.isInteger ? 5.0 : 5.0;
                final newValue = (widget.value - decrement).clamp(widget.min, widget.max);
                if (newValue != widget.value) {
                  HapticFeedback.lightImpact();
                  widget.onChanged(newValue);
                }
              },
              theme: theme,
            ),
            SizedBox(width: theme.spaceSmall),
            _QuickButton(
              label: '-10',
              onPressed: () {
                final decrement = widget.isInteger ? 10.0 : 10.0;
                final newValue = (widget.value - decrement).clamp(widget.min, widget.max);
                if (newValue != widget.value) {
                  HapticFeedback.mediumImpact();
                  widget.onChanged(newValue);
                }
              },
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

/// Quick increment/decrement button
class _QuickButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ThemeService theme;

  const _QuickButton({
    required this.label,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        foregroundColor: theme.healthPrimary,
        padding: EdgeInsets.symmetric(
          horizontal: theme.paddingMedium,
          vertical: theme.paddingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
