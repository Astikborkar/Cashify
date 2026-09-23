import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Reusable surface container card with border, subtle shadow, and tap interactions.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final bool isSelected;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = isSelected
        ? Border.all(color: AppColors.primary, width: 2)
        : (border ?? Border.all(color: AppColors.borderLight, width: 1));

    final effectiveBg = isSelected
        ? AppColors.primaryLight
        : (backgroundColor ?? AppColors.surfaceLight);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: borderRadius ?? AppSpacing.roundedLg,
        border: effectiveBorder,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppSpacing.roundedLg,
          child: Padding(
            padding: padding ?? AppSpacing.cardPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
