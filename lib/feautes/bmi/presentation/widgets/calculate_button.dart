import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/entities/bmi_input.dart';
import '../../data/entities/bmi_result.dart';
import '../../data/usecases/calculate_bmi.dart';

/// Enhanced calculate button with intelligence framing and processing states
/// Provides "Get Health Intelligence" experience with visual feedback
class CalculateButton extends ConsumerStatefulWidget {
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
  ConsumerState<CalculateButton> createState() => _CalculateButtonState();
}

class _CalculateButtonState extends ConsumerState<CalculateButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late AnimationController _processingController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _processingAnimation;

  bool _isProcessing = false;
  bool _isComplete = false;

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

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _processingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _processingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _processingController,
      curve: Curves.easeInOut,
    ));

    // Start subtle shimmer effect when enabled
    if (!widget.isLoading) {
      _shimmerController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CalculateButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading && oldWidget.isLoading) {
      _shimmerController.repeat(reverse: true);
    } else if (widget.isLoading && !oldWidget.isLoading) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    _processingController.dispose();
    super.dispose();
  }

  Future<void> _onPressed() async {
    if (widget.isLoading || _isProcessing) return;

    // Start processing state
    setState(() => _isProcessing = true);
    _shimmerController.stop();
    _processingController.forward();
    
    ref.read(hapticServiceProvider).medium();

    // Simulate processing time for user perception of value
    await Future.delayed(const Duration(milliseconds: 1200));

    // Complete state
    setState(() {
      _isProcessing = false;
      _isComplete = true;
    });

    ref.read(hapticServiceProvider).success();

    // Navigate after brief success display
    await Future.delayed(const Duration(milliseconds: 600));
    widget.onPressed();
  }

  BMIResult _calculatePreview() {
    final useCase = CalculateBMIUseCase();
    return useCase(widget.input);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final result = _calculatePreview();
    final isEnabled = !widget.isLoading;
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        _scaleAnimation,
        _shimmerAnimation,
        _processingAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => isEnabled ? _scaleController.forward() : null,
            onTapUp: (_) => isEnabled ? _scaleController.reverse() : null,
            onTapCancel: () => isEnabled ? _scaleController.reverse() : null,
            onTap: _onPressed,
            child: Container(
              height: 64,
              margin: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
              decoration: BoxDecoration(
                gradient: _buildGradient(theme, result, isEnabled),
                borderRadius: theme.borderRadiusMedium,
                boxShadow: [
                  BoxShadow(
                    color: (isEnabled ? theme.healthPrimary : theme.colorScheme.outline)
                        .withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shimmer effect
                  if (isEnabled && !_isProcessing && !_isComplete)
                    _ShimmerOverlay(
                      animation: _shimmerAnimation,
                      theme: theme,
                    ),
                  
                  // Main content
                  Center(
                    child: _ButtonContent(
                      isProcessing: _isProcessing,
                      isComplete: _isComplete,
                      isEnabled: isEnabled,
                      processingAnimation: _processingAnimation,
                      result: result,
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LinearGradient _buildGradient(ThemeService theme, BMIResult result, bool isEnabled) {
    if (!isEnabled) {
      return LinearGradient(
        colors: [
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.surfaceContainerHigh,
        ],
      );
    }

    if (_isComplete) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          result.category.color.withOpacity(0.9),
          result.category.color.withOpacity(0.7),
          theme.healthSecondary.withOpacity(0.8),
        ],
        stops: const [0.0, 0.6, 1.0],
      );
    }

    if (_isProcessing) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.healthSecondary.withOpacity(0.8),
          theme.healthPrimary.withOpacity(0.6),
        ],
      );
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.healthPrimary.withOpacity(0.9),
        theme.healthSecondary.withOpacity(0.8),
        theme.colorScheme.tertiary.withOpacity(0.7),
      ],
      stops: const [0.0, 0.6, 1.0],
    );
  }
}

/// Shimmer overlay for visual appeal
class _ShimmerOverlay extends StatelessWidget {
  final Animation<double> animation;
  final ThemeService theme;

  const _ShimmerOverlay({
    required this.animation,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: theme.borderRadiusMedium,
        child: Transform.translate(
          offset: Offset(animation.value * MediaQuery.of(context).size.width, 0),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Button content with different states
class _ButtonContent extends StatelessWidget {
  final bool isProcessing;
  final bool isComplete;
  final bool isEnabled;
  final Animation<double> processingAnimation;
  final BMIResult result;
  final ThemeService theme;

  const _ButtonContent({
    required this.isProcessing,
    required this.isComplete,
    required this.isEnabled,
    required this.processingAnimation,
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (isComplete) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: theme.iconSizeMedium,
          ),
          SizedBox(width: theme.spaceSmall),
          Text(
            'BMI: ${result.formattedBMI} (${result.category.label})',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (isProcessing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: theme.iconSizeMedium,
            height: theme.iconSizeMedium,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              value: processingAnimation.value,
            ),
          ),
          SizedBox(width: theme.spaceMedium),
          Text(
            'Analyzing your health data...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(theme.paddingXS),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: theme.borderRadiusSmall,
          ),
          child: Icon(
            Icons.psychology,
            color: Colors.white,
            size: theme.iconSizeSmall,
          ),
        ),
        SizedBox(width: theme.spaceSmall),
        Text(
          '🧠 Get Health Intelligence',
          style: theme.textTheme.titleMedium?.copyWith(
            color: isEnabled ? Colors.white : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}