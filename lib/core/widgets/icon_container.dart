import 'package:bmi_calculator/core/services/theme_service.dart';
import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;

  const IconContainer({super.key, required this.icon, this.color = Colors.white,});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeService;
    return Container(
          padding: EdgeInsets.all(theme.paddingSmall),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.healthPrimary, theme.healthSecondary],
            ),
            borderRadius: theme.borderRadiusSmall,
          ),
          child: Icon(
            icon ,
            color: color,
            size: theme.iconSizeSmall,
          ),
        );
  }
}