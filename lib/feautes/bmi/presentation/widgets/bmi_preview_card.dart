import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/constants/colors.dart';
import '../../data/entities/bmi_input.dart';
import '../../data/entities/bmi_result.dart';
import '../../data/usecases/calculate_bmi.dart';

/// Real-time BMI preview card with visual feedback
/// Shows live BMI calculation as user inputs data
class BMIPreviewCard extends StatefulWidget {
  final BMIInput input;
  final VoidCallback? onPreviewTap;

  const BMIPreviewCard({
    super.key,
    required this.input,
    this.onPreviewTap,
  });

  @override
  State<BMIPreviewCard> createState() => _BMIPreviewCardState();
}

class _BMIPreviewCardState extends State<BMIPreviewCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _colorController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  late CalculateBMIUseCase _calculateBMI;
  late double _previousBMI;

  @override
  void initState() {
    super.initState();
    _calculateBMI = CalculateBMIUseCase();
    _previousBMI = _calculateCurrentBMI();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    final currentBMI = _calculateCurrentBMI();
    final bmiColor = HealthColors.getBMIColor(currentBMI);
    
    _colorAnimation = ColorTween(
      begin: bmiColor.withOpacity(0.1),
      end: bmiColor.withOpacity(0.2),
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(BMIPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final currentBMI = _calculateCurrentBMI();
    if ((currentBMI - _previousBMI).abs() > 0.1) {
      _triggerUpdateAnimation();
      _previousBMI = currentBMI;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  double _calculateCurrentBMI() {
    final heightM = widget.input.height / 100;
    return widget.input.weight / (heightM * heightM);
  }

  void _triggerUpdateAnimation() {
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
    _colorController.forward().then((_) {
      _colorController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final result = _calculateBMI(widget.input);
    
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onPreviewTap?.call();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: theme.paddingMedium),
              padding: theme.cardPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    result.category.color.withOpacity(0.1),
                    result.category.color.withOpacity(0.05),
                  ],
                ),
                borderRadius: theme.cardRadius,
                border: Border.all(
                  color: result.category.color.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: result.category.color.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: result.category.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.speed,
                          color: result.category.color,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: theme.spaceMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BMI Preview',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.healthOnSurface,
                              ),
                            ),
                            Text(
                              'Tap for detailed analysis',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.healthOnSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: result.category.color,
                        size: 16,
                      ),
                    ],
                  ),

                  SizedBox(height: theme.spaceLarge),

                  // BMI Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // BMI Value
                      _BMIValueDisplay(
                        bmi: result.bmi,
                        color: result.category.color,
                        theme: theme,
                      ),

                      // Vertical Divider
                      Container(
                        height: 60,
                        width: 1,
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),

                      // Category
                      _BMICategoryDisplay(
                        category: result.category,
                        theme: theme,
                      ),
                    ],
                  ),

                  SizedBox(height: theme.spaceLarge),

                  // BMI Range Indicator
                  _BMIRangeIndicator(
                    bmi: result.bmi,
                    category: result.category,
                    theme: theme,
                  ),

                  SizedBox(height: theme.spaceMedium),

                  // Quick Status
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.paddingMedium,
                      vertical: theme.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: result.category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          result.category.emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: theme.spaceSmall),
                        Text(
                          _getQuickStatus(result.category),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: result.category.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  String _getQuickStatus(BMICategory category) {
    switch (category) {
      case BMICategory.severelyUnderweight:
        return 'Needs medical attention';
      case BMICategory.underweight:
        return 'Below healthy range';
      case BMICategory.normal:
        return 'Healthy range';
      case BMICategory.overweight:
        return 'Above healthy range';
      case BMICategory.moderatelyObese:
        return 'Consider lifestyle changes';
      case BMICategory.severelyObese:
        return 'Consult healthcare provider';
      case BMICategory.verySeverelyObese:
        return 'Consult healthcare provider';
    }
  }
}

/// BMI value display with animated transitions
class _BMIValueDisplay extends StatelessWidget {
  final double bmi;
  final Color color;
  final ThemeService theme;

  const _BMIValueDisplay({
    required this.bmi,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: theme.mediumAnimation,
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
            bmi.toStringAsFixed(1),
            key: ValueKey(bmi.toStringAsFixed(1)),
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: theme.spaceXS),
        Text(
          'BMI',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.healthOnSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// BMI category display with icon
class _BMICategoryDisplay extends StatelessWidget {
  final BMICategory category;
  final ThemeService theme;

  const _BMICategoryDisplay({
    required this.category,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            category.emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(height: theme.spaceSmall),
        Text(
          category.label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: category.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// BMI range indicator showing position on scale
class _BMIRangeIndicator extends StatelessWidget {
  final double bmi;
  final BMICategory category;
  final ThemeService theme;

  const _BMIRangeIndicator({
    required this.bmi,
    required this.category,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'BMI Range',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.healthOnSurface.withOpacity(0.6),
          ),
        ),
        SizedBox(height: theme.spaceSmall),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomPaint(
            painter: _BMIRangePainter(
              bmi: bmi,
              category: category,
            ),
            size: Size(MediaQuery.of(context).size.width - 64, 8),
          ),
        ),
        SizedBox(height: theme.spaceSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '18.5',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.healthOnSurface.withOpacity(0.6),
              ),
            ),
            Text(
              '25',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.healthOnSurface.withOpacity(0.6),
              ),
            ),
            Text(
              '30',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.healthOnSurface.withOpacity(0.6),
              ),
            ),
            Text(
              '35+',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.healthOnSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom painter for BMI range visualization
class _BMIRangePainter extends CustomPainter {
  final double bmi;
  final BMICategory category;

  _BMIRangePainter({
    required this.bmi,
    required this.category,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw background ranges
    final ranges = [
      (0.0, 0.25, HealthColors.bmiUnderweight),      // Underweight
      (0.25, 0.5, HealthColors.bmiNormal),          // Normal
      (0.5, 0.75, HealthColors.bmiOverweight),      // Overweight
      (0.75, 1.0, HealthColors.bmiModeratelyObese), // Obese
    ];

    for (final (start, end, color) in ranges) {
      paint.color = color.withOpacity(0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            start * size.width,
            0,
            (end - start) * size.width,
            size.height,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
    }

    // Calculate BMI position (clamped between 15 and 40 for display)
    final clampedBMI = bmi.clamp(15.0, 40.0);
    final position = (clampedBMI - 15.0) / (40.0 - 15.0);

    // Draw current BMI indicator
    paint.color = category.color;
    canvas.drawCircle(
      Offset(position * size.width, size.height / 2),
      6,
      paint,
    );

    // Draw indicator border
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(position * size.width, size.height / 2),
      6,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BMIRangePainter oldDelegate) {
    return oldDelegate.bmi != bmi || oldDelegate.category != category;
  }
}
