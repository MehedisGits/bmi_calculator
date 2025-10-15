import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/entities/bmi_input.dart';

/// Interactive gender selector with smooth animations and visual feedback
/// Provides an intuitive way to select gender with micro-interactions
class GenderSelector extends ConsumerStatefulWidget {
  final Gender selectedGender;
  final ValueChanged<Gender> onGenderChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  ConsumerState<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends ConsumerState<GenderSelector>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

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

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onGenderTap(Gender gender) {
    if (gender != widget.selectedGender) {
      ref.read(hapticServiceProvider).medium();
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      widget.onGenderChanged(gender);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Row(
      children: Gender.values.map((gender) {
        final isSelected = widget.selectedGender == gender;
        
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.paddingSmall),
            child: _GenderCard(
              gender: gender,
              isSelected: isSelected,
              onTap: () => _onGenderTap(gender),
              scaleAnimation: _scaleAnimation,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Individual gender card with animations and visual feedback
class _GenderCard extends StatelessWidget {
  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;
  final Animation<double> scaleAnimation;

  const _GenderCard({
    required this.gender,
    required this.isSelected,
    required this.onTap,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: theme.mediumAnimation,
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                vertical: theme.paddingLarge,
                horizontal: theme.paddingMedium,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          gender.color.withOpacity(0.15),
                          gender.color.withOpacity(0.05),
                        ],
                      )
                    : null,
                border: Border.all(
                  color: isSelected
                      ? gender.color
                      : theme.colorScheme.outline.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: theme.cardRadius,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: gender.color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gender Icon with Animation
                  AnimatedDefaultTextStyle(
                    duration: theme.mediumAnimation,
                    style: TextStyle(
                      fontSize: isSelected ? 48 : 40,
                    ),
                    child: ZoomIn(
                      duration: theme.fastAnimation,
                      child: Text(gender.icon),
                    ),
                  ),
                  
                  SizedBox(height: theme.spaceMedium),
                  
                  // Gender Label
                  AnimatedDefaultTextStyle(
                    duration: theme.mediumAnimation,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? gender.color : theme.healthOnSurface,
                    ) ?? const TextStyle(),
                    child: Text(gender.label),
                  ),
                  
                  // Selection Indicator
                  SizedBox(height: theme.spaceSmall),
                  AnimatedContainer(
                    duration: theme.mediumAnimation,
                    width: isSelected ? 32 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: gender.color,
                      borderRadius: BorderRadius.circular(2),
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
}

/// Gender selection with segmented control style (alternative design)
class GenderSegmentedSelector extends ConsumerWidget {
  final Gender selectedGender;
  final ValueChanged<Gender> onGenderChanged;

  const GenderSegmentedSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themeService;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: theme.cardRadius,
      ),
      child: Row(
        children: Gender.values.map((gender) {
          final isSelected = selectedGender == gender;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(hapticServiceProvider).light();
                onGenderChanged(gender);
              },
              child: AnimatedContainer(
                duration: theme.mediumAnimation,
                padding: EdgeInsets.symmetric(
                  vertical: theme.paddingMedium,
                  horizontal: theme.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? theme.healthPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(theme.radiusMedium.topLeft.x - 4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gender.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: theme.spaceSmall),
                    Text(
                      gender.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : theme.healthOnSurface,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
