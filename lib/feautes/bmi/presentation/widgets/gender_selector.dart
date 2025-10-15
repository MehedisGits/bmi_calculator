import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/entities/bmi_input.dart';

/// Enhanced gender selector with horizontal toggle following UX strategy
/// Provides streamlined selection with smooth animations and micro-interactions
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
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _selectionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  void _onGenderSelected(Gender gender) {
    if (gender != widget.selectedGender) {
      ref.read(hapticServiceProvider).light();
      _selectionController.forward().then((_) {
        _selectionController.reverse();
      });
      widget.onGenderChanged(gender);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        _InputLabel(
          icon: '👤',
          label: 'I am',
          theme: theme,
        ),
        
        SizedBox(height: theme.spaceSmall),
        
        // Toggle interface
        AnimatedBuilder(
          animation: _selectionAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 - (_selectionAnimation.value * 0.02),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: theme.borderRadiusMedium,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Selection indicator (sliding background)
                    AnimatedPositioned(
                      duration: theme.fastAnimation,
                      curve: Curves.easeInOut,
                      left: widget.selectedGender == Gender.male ? 4 : null,
                      right: widget.selectedGender == Gender.female ? 4 : null,
                      top: 4,
                      bottom: 4,
                      width: (MediaQuery.of(context).size.width - 64) / 2 - 8,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.selectedGender.color.withOpacity(0.9),
                              widget.selectedGender.color.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: theme.borderRadiusSmall,
                          boxShadow: [
                            BoxShadow(
                              color: widget.selectedGender.color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Gender options
                    Row(
                      children: Gender.values.map((gender) {
                        final isSelected = widget.selectedGender == gender;
                        
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onGenderSelected(gender),
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: theme.borderRadiusSmall,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      gender.icon,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(width: theme.spaceXS),
                                    AnimatedDefaultTextStyle(
                                      duration: theme.fastAnimation,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: isSelected 
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                        fontWeight: isSelected 
                                          ? FontWeight.w600 
                                          : FontWeight.w500,
                                      ) ?? const TextStyle(),
                                      child: Text(gender.label),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Reusable input label component following design system
class _InputLabel extends StatelessWidget {
  final String icon;
  final String label;
  final ThemeService theme;

  const _InputLabel({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          icon,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
          ),
        ),
        SizedBox(width: theme.spaceXS),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}