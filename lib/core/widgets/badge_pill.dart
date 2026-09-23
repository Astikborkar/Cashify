import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum BadgeType { gradeSuperb, gradeGood, gradeFair, discount, warranty, custom }

/// Pill badge for Refurbished grades, discounts, and order statuses.
class BadgePill extends StatelessWidget {
  final String text;
  final BadgeType type;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const BadgePill({
    super.key,
    required this.text,
    this.type = BadgeType.custom,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.gradeSuperb:
        bg = AppColors.primaryLight;
        fg = AppColors.primaryDark;
        break;
      case BadgeType.gradeGood:
        bg = AppColors.secondaryLight;
        fg = AppColors.secondaryDark;
        break;
      case BadgeType.gradeFair:
        bg = AppColors.accentLight;
        fg = const Color(0xFFC67C00);
        break;
      case BadgeType.discount:
        bg = AppColors.errorLight;
        fg = AppColors.error;
        break;
      case BadgeType.warranty:
        bg = AppColors.primaryLight;
        fg = AppColors.primaryDark;
        break;
      case BadgeType.custom:
        bg = backgroundColor ?? AppColors.neutral100;
        fg = textColor ?? AppColors.neutral700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.roundedPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
