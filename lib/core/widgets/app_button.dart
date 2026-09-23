import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum ButtonVariant { filled, outline, ghost }

/// Standard reusable button for Cashify Clone.
/// Implements 52px touch-friendly height, loading spinners, and variant styles.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final Color? customColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.filled,
    this.isLoading = false,
    this.icon,
    this.width,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = customColor ?? AppColors.primary;
    final isEnabled = onPressed != null && !isLoading;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.filled ? Colors.white : effectiveColor,
              ),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              color: variant == ButtonVariant.filled
                  ? (isEnabled ? Colors.white : AppColors.neutral500)
                  : (isEnabled ? effectiveColor : AppColors.neutral500),
            ),
          ),
        ],
      ],
    );

    ButtonStyle style;
    switch (variant) {
      case ButtonVariant.filled:
        style = ElevatedButton.styleFrom(
          backgroundColor: effectiveColor,
          disabledBackgroundColor: AppColors.neutral300,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        );
        break;
      case ButtonVariant.outline:
        style = OutlinedButton.styleFrom(
          foregroundColor: effectiveColor,
          side: BorderSide(
            color: isEnabled ? effectiveColor : AppColors.neutral300,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        );
        break;
      case ButtonVariant.ghost:
        style = TextButton.styleFrom(
          foregroundColor: effectiveColor,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
        );
        break;
    }

    return SizedBox(
      height: 52,
      width: width ?? double.infinity,
      child: variant == ButtonVariant.filled
          ? ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              style: style,
              child: content,
            )
          : variant == ButtonVariant.outline
              ? OutlinedButton(
                  onPressed: isEnabled ? onPressed : null,
                  style: style,
                  child: content,
                )
              : TextButton(
                  onPressed: isEnabled ? onPressed : null,
                  style: style,
                  child: content,
                ),
    );
  }
}
