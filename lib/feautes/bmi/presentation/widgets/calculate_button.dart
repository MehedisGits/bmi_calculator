import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/theme_service.dart';
import '../../data/entities/bmi_input.dart';
import '../../data/entities/bmi_result.dart';
import '../../data/usecases/calculate_bmi.dart';

/// Interactive calculate button with states and visual feedback
/// Provides clear call-to-action with loading and success states
class CalculateButton extends StatefulWidget {
  final BMIInput input;
  final VoidCallback onPressed;
  final bool isLoading;

  const CalculateButton({
    super.key,
    required this.input,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<CalculateButton> createState() => _CalculateButtonState();
}

class _CalculateButtonState extends State<CalculateButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _colorController;
  late AnimationController _loadingController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  late Animation<double> _loadingAnimation;

  bool _isPressed = false;
  late CalculateBMIUseCase _calculateBMI;

  @override
  void initState() {
    super.initState();
    _calculateBMI = CalculateBMIUseCase();
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

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(CalculateButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _loadingController.repeat();
      } else {
        _loadingController.stop();
        _loadingController.reset();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _colorController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
    _colorController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    _colorController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    _colorController.reverse();
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final result = _calculateBMI(widget.input);
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _colorAnimation,
        _loadingAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isLoading ? null : _onTap,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isLoading
                      ? [
                          theme.colorScheme.outline.withOpacity(0.5),
                          theme.colorScheme.outline.withOpacity(0.3),
                        ]
                      : [
                          Color.lerp(theme.healthPrimary, theme.healthSecondary, _colorAnimation.value) ?? theme.healthPrimary,
                          theme.healthSecondary,
                        ],
                ),
                borderRadius: theme.buttonRadius,
                boxShadow: widget.isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: (Color.lerp(theme.healthPrimary, theme.healthSecondary, _colorAnimation.value) ?? theme.healthPrimary)
                              .withOpacity(0.4),
                          blurRadius: _isPressed ? 8 : 16,
                          offset: Offset(0, _isPressed ? 2 : 4),
                        ),
                      ],
              ),
              child: widget.isLoading
                  ? _LoadingContent(
                      animation: _loadingAnimation,
                      theme: theme,
                    )
                  : _ButtonContent(
                      result: result,
                      theme: theme,
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// Button content with BMI preview
class _ButtonContent extends StatelessWidget {
  final BMIResult result;
  final ThemeService theme;

  const _ButtonContent({
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calculate,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        SizedBox(width: theme.spaceMedium),
        
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculate BMI',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'BMI: ${result.bmi.toStringAsFixed(1)} • ${result.category.label}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.category.emoji,
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(width: theme.spaceSmall),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Loading content with animated indicator
class _LoadingContent extends StatelessWidget {
  final Animation<double> animation;
  final ThemeService theme;

  const _LoadingContent({
    required this.animation,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: animation.value * 2 * 3.14159,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24,
              ),
            );
          },
        ),
        
        SizedBox(width: theme.spaceMedium),
        
        Text(
          'Calculating...',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Compact calculate button for smaller spaces
class CompactCalculateButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const CompactCalculateButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<CompactCalculateButton> createState() => _CompactCalculateButtonState();
}

class _CompactCalculateButtonState extends State<CompactCalculateButton>
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
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.isLoading ? null : _onTapDown,
            onTapUp: widget.isLoading ? null : _onTapUp,
            onTapCancel: widget.isLoading ? null : _onTapCancel,
            onTap: widget.isLoading ? null : widget.onPressed,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.isLoading
                    ? theme.colorScheme.outline.withOpacity(0.5)
                    : theme.healthPrimary,
                shape: BoxShape.circle,
                boxShadow: widget.isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: theme.healthPrimary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.calculate,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// Floating action button style calculate button
class FloatingCalculateButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  const FloatingCalculateButton({
    super.key,
    required this.onPressed,
    this.isVisible = true,
  });

  @override
  State<FloatingCalculateButton> createState() => _FloatingCalculateButtonState();
}

class _FloatingCalculateButtonState extends State<FloatingCalculateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FloatingCalculateButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: widget.onPressed,
              backgroundColor: theme.healthPrimary,
              foregroundColor: Colors.white,
              elevation: 8,
              icon: const Icon(Icons.calculate),
              label: Text(
                'Calculate BMI',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
