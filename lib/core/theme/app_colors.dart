import 'package:flutter/material.dart';

/// Design tokens for Cashify Clone application.
/// Matches the specifications outlined in design-system.md.
class AppColors {
  AppColors._();

  // Brand Primary & Accents
  static const Color primary = Color(0xFF00C853);
  static const Color primaryDark = Color(0xFF009624);
  static const Color primaryLight = Color(0xFFE8F8EE);

  // Secondary (Trust & Info)
  static const Color secondary = Color(0xFF2962FF);
  static const Color secondaryDark = Color(0xFF0039CB);
  static const Color secondaryLight = Color(0xFFEBF2FF);

  // Accent & Warnings
  static const Color accent = Color(0xFFFFB300);
  static const Color accentLight = Color(0xFFFFF8E1);

  // Semantic Status
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color success = Color(0xFF43A047);
  static const Color successLight = Color(0xFFE8F5E9);

  // Light Theme Surfaces & Backgrounds
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE0E0E0);

  // Dark Theme Surfaces & Backgrounds
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color borderDark = Color(0xFF2C2C2C);

  // Neutral Monochrome Palette
  static const Color neutral900 = Color(0xFF1A1D20);
  static const Color neutral700 = Color(0xFF4A5568);
  static const Color neutral500 = Color(0xFF718096);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral50 = Color(0xFFF8FAFC);
}
