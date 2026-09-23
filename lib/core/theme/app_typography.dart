import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography hierarchy for Cashify Clone based on the 8-level scale.
class AppTypography {
  AppTypography._();

  static TextTheme createTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.neutral900;
    final secondaryTextColor = isDark ? AppColors.neutral300 : AppColors.neutral700;

    return TextTheme(
      // H1 / Display (34sp, Bold) - Used for instant quotes and prominent sums
      displayLarge: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.18,
        letterSpacing: -0.5,
        color: primaryTextColor,
      ),
      // H2 / Headline (28sp, SemiBold) - Screen headers
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.21,
        letterSpacing: -0.2,
        color: primaryTextColor,
      ),
      // H3 / Subheading (22sp, SemiBold) - Section titles
      headlineSmall: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: primaryTextColor,
      ),
      // Title Large (18sp, Medium) - AppBars and Card Headers
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: primaryTextColor,
      ),
      // Title Medium (16sp, SemiBold) - Product names and price tags
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.38,
        color: primaryTextColor,
      ),
      // Body Regular (16sp, Regular) - Descriptive reading text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryTextColor,
      ),
      // Body Small (14sp, Regular) - Specs, Form helper text
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        color: secondaryTextColor,
      ),
      // Caption / Label (12sp, Medium) - Badges, chips, timestamps
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.2,
        color: secondaryTextColor,
      ),
    );
  }
}
