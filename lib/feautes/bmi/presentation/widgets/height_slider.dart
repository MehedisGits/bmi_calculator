import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/services/theme_service.dart';

/// Interactive height slider with visual feedback and micro-interactions
/// Provides an intuitive way to select height with real-time feedback
class HeightSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const HeightSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 100,
    this.max = 220,
  });

  @override
  State<HeightSlider> createState() => _HeightSliderState();
}

class _HeightSliderState extends State<HeightSlider>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onSliderStart(double value) {
    setState(() => _isActive = true);
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
    HapticFeedback.lightImpact();
  }

  void _onSliderEnd(double value) {
    setState(() => _isActive = false);
    _scaleController.reverse();
    _pulseController.stop();
    _pulseController.reset();
    HapticFeedback.mediumImpact();
  }

  void _onSliderChanged(double value) {
    widget.onChanged(value);
    // Light haptic feedback every 5cm
    if ((value % 5).abs() < 0.5) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Column(
      children: [
        // Height Display
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _HeightDisplay(
                height: widget.value,
                isActive: _isActive,
                pulseAnimation: _pulseAnimation,
              ),
            );
          },
        ),

        SizedBox(height: theme.spaceLarge),

        // Height Visualization
        _HeightVisualization(
          height: widget.value,
          min: widget.min,
          max: widget.max,
          isActive: _isActive,
        ),

        SizedBox(height: theme.spaceLarge),

        // Slider
        _CustomSlider(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          onChanged: _onSliderChanged,
          onChangeStart: _onSliderStart,
          onChangeEnd: _onSliderEnd,
          isActive: _isActive,
        ),

        SizedBox(height: theme.spaceMedium),

        // Height Scale Labels
        _HeightScaleLabels(
          min: widget.min,
          max: widget.max,
          currentValue: widget.value,
        ),
      ],
    );
  }
}

/// Height display with animated feedback
class _HeightDisplay extends StatelessWidget {
  final double height;
  final bool isActive;
  final Animation<double> pulseAnimation;

  const _HeightDisplay({
    required this.height,
    required this.isActive,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? pulseAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: theme.paddingXLarge,
              vertical: theme.paddingMedium,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.healthPrimary.withOpacity(isActive ? 0.2 : 0.1),
                  theme.healthSecondary.withOpacity(isActive ? 0.1 : 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: theme.healthPrimary.withOpacity(isActive ? 0.5 : 0.3),
                width: isActive ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.height,
                  color: theme.healthPrimary,
                  size: 24,
                ),
                SizedBox(width: theme.spaceSmall),
                AnimatedDefaultTextStyle(
                  duration: theme.fastAnimation,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.healthPrimary,
                    fontSize: isActive ? 32 : 28,
                  ) ?? const TextStyle(),
                  child: Text('${height.round()}'),
                ),
                SizedBox(width: theme.spaceSmall),
                AnimatedDefaultTextStyle(
                  duration: theme.fastAnimation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.healthPrimary.withOpacity(0.8),
                    fontSize: isActive ? 18 : 16,
                  ) ?? const TextStyle(),
                  child: const Text('cm'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Visual representation of height with human silhouette
class _HeightVisualization extends StatelessWidget {
  final double height;
  final double min;
  final double max;
  final bool isActive;

  const _HeightVisualization({
    required this.height,
    required this.min,
    required this.max,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final progress = (height - min) / (max - min);
    
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: theme.paddingLarge),
      child: Stack(
        children: [
          // Background scale
          Positioned.fill(
            child: CustomPaint(
              painter: _HeightScalePainter(
                progress: progress,
                color: theme.healthPrimary,
                isActive: isActive,
              ),
            ),
          ),
          
          // Human silhouette
          Positioned(
            left: progress * (MediaQuery.of(context).size.width - theme.paddingLarge * 4),
            top: (1 - progress) * 80,
            child: AnimatedContainer(
              duration: theme.fastAnimation,
              child: Icon(
                Icons.person,
                size: isActive ? 32 : 28,
                color: theme.healthPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom slider with enhanced styling
class _CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final bool isActive;

  const _CustomSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: isActive ? 8 : 6,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: isActive ? 16 : 14,
          elevation: isActive ? 8 : 4,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: isActive ? 32 : 28,
        ),
        activeTrackColor: theme.healthPrimary,
        inactiveTrackColor: theme.healthPrimary.withOpacity(0.3),
        thumbColor: theme.healthPrimary,
        overlayColor: theme.healthPrimary.withOpacity(0.1),
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: theme.healthPrimary,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: (max - min).round(),
        label: '${value.round()} cm',
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}

/// Scale labels showing height ranges
class _HeightScaleLabels extends StatelessWidget {
  final double min;
  final double max;
  final double currentValue;

  const _HeightScaleLabels({
    required this.min,
    required this.max,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.paddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ScaleLabel(
            value: min,
            isActive: (currentValue - min).abs() < 10,
            theme: theme,
          ),
          _ScaleLabel(
            value: (min + max) / 2,
            isActive: (currentValue - (min + max) / 2).abs() < 10,
            theme: theme,
          ),
          _ScaleLabel(
            value: max,
            isActive: (currentValue - max).abs() < 10,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

/// Individual scale label
class _ScaleLabel extends StatelessWidget {
  final double value;
  final bool isActive;
  final ThemeService theme;

  const _ScaleLabel({
    required this.value,
    required this.isActive,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: theme.fastAnimation,
      style: theme.textTheme.bodySmall?.copyWith(
        color: isActive 
            ? theme.healthPrimary 
            : theme.healthOnSurface.withOpacity(0.6),
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ) ?? const TextStyle(),
      child: Text('${value.round()}cm'),
    );
  }
}

/// Custom painter for height scale visualization
class _HeightScalePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isActive;

  _HeightScalePainter({
    required this.progress,
    required this.color,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = color.withOpacity(isActive ? 0.3 : 0.2)
      ..strokeWidth = isActive ? 3 : 2
      ..style = PaintingStyle.stroke;

    // Draw background scale lines
    for (int i = 0; i <= 10; i++) {
      final x = (i / 10) * size.width;
      final height = i % 5 == 0 ? size.height * 0.6 : size.height * 0.3;
      
      canvas.drawLine(
        Offset(x, size.height - height),
        Offset(x, size.height),
        i / 10 <= progress ? activePaint : paint,
      );
    }

    // Draw progress line
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = isActive ? 4 : 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height - 10),
      Offset(progress * size.width, size.height - 10),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HeightScalePainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.isActive != isActive;
  }
}
