import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/config/bmi_config.dart';

/// Enhanced height slider with visual progress and real-time feedback
/// Provides immediate visual progress indication and smooth micro-interactions
class HeightSlider extends ConsumerStatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double? min;
  final double? max;

  const HeightSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min,
    this.max,
  });

  @override
  ConsumerState<HeightSlider> createState() => _HeightSliderState();
}

class _HeightSliderState extends ConsumerState<HeightSlider>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onSliderStart(double value) {
    setState(() => _isInteracting = true);
    _pulseController.repeat(reverse: true);
  }

  void _onSliderEnd(double value) {
    setState(() => _isInteracting = false);
    _pulseController.stop();
    _pulseController.reset();
    ref.read(hapticServiceProvider).light();
  }

  void _onSliderChanged(double value) {
    final haptic = ref.read(hapticServiceProvider);
    
    // Provide haptic feedback at key intervals
    if (value % 5 == 0) {
      haptic.light();
    }
    
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    final limits = BMIConfig.heightLimits;
    final minValue = widget.min ?? limits.min;
    final maxValue = widget.max ?? limits.max;
    final progress = (widget.value - minValue) / (maxValue - minValue);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with current value
        _HeightLabel(
          value: widget.value,
          theme: theme,
        ),
        
        SizedBox(height: theme.spaceSmall),
        
        // Visual progress track
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isInteracting ? _pulseAnimation.value : 1.0,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: theme.borderRadiusMedium,
                  border: Border.all(
                    color: _isInteracting
                        ? theme.healthPrimary.withOpacity(0.3)
                        : theme.colorScheme.outlineVariant.withOpacity(0.5),
                    width: _isInteracting ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background track
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: theme.borderRadiusSmall,
                      ),
                    ),
                    
                    // Progress fill
                    AnimatedContainer(
                      duration: _isInteracting 
                          ? Duration.zero 
                          : theme.fastAnimation,
                      width: MediaQuery.of(context).size.width * progress - 32,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            theme.healthPrimary.withOpacity(0.8),
                            theme.healthPrimary.withOpacity(0.6),
                            theme.healthSecondary.withOpacity(0.4),
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                        borderRadius: theme.borderRadiusSmall,
                      ),
                    ),
                    
                    // Progress markers (visual guide lines)
                    _ProgressMarkers(
                      minValue: minValue,
                      maxValue: maxValue,
                      theme: theme,
                    ),
                    
                    // Interactive slider (invisible overlay)
                    Positioned.fill(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 0,
                          thumbColor: Colors.transparent,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: widget.value,
                          min: minValue,
                          max: maxValue,
                          divisions: ((maxValue - minValue) / limits.step).round(),
                          onChangeStart: _onSliderStart,
                          onChangeEnd: _onSliderEnd,
                          onChanged: _onSliderChanged,
                        ),
                      ),
                    ),
                    
                    // Thumb indicator
                    AnimatedPositioned(
                      duration: _isInteracting 
                          ? Duration.zero 
                          : theme.fastAnimation,
                      left: (MediaQuery.of(context).size.width - 64) * progress - 12,
                      top: 8,
                      bottom: 8,
                      child: Container(
                        width: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: theme.borderRadiusSmall,
                          border: Border.all(
                            color: theme.healthPrimary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.healthPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.height,
                            size: 16,
                            color: theme.healthPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: theme.spaceXS),
        
        // Range indicators
        _RangeIndicators(
          minValue: minValue,
          maxValue: maxValue,
          theme: theme,
        ),
      ],
    );
  }
}

/// Height label with emoji and current value display
class _HeightLabel extends StatelessWidget {
  final double value;
  final ThemeService theme;

  const _HeightLabel({
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '📏',
          style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        SizedBox(width: theme.spaceXS),
        Text(
          'Height:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
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
            '${value.toInt()} cm',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.healthPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Progress markers for visual guidance
class _ProgressMarkers extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final ThemeService theme;

  const _ProgressMarkers({
    required this.minValue,
    required this.maxValue,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final markers = <double>[
      150, 160, 170, 180, 190, 200
    ].where((height) => height >= minValue && height <= maxValue);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: markers.map((height) {
        final progress = (height - minValue) / (maxValue - minValue);
        
        return Positioned(
          left: (MediaQuery.of(context).size.width - 64) * progress,
          child: Container(
            width: 1,
            height: double.infinity,
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          ),
        );
      }).toList(),
    );
  }
}

/// Range indicators showing min and max values
class _RangeIndicators extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final ThemeService theme;

  const _RangeIndicators({
    required this.minValue,
    required this.maxValue,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${minValue.toInt()} cm',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${maxValue.toInt()} cm',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}