import 'package:flutter/material.dart';

/// App-wide constants for theming, colors, and sizing.
/// Guardian Net Premium Brand Identity: Dark Green & Luxury Gold.
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────────────
  static const String appName = 'GuardianNet';
  static const String appTagline = 'Safe, Simple, and Connected.';

  static const String googleSignInWebClientId =
      '1071073494722-vgdqe9ph1le91km07lot74b7p2vohr1q.apps.googleusercontent.com';

  // ── Brand Colors ──────────────────────────────────────────────────────
  // Primary Dark Green (Main Brand Color)
  static const Color primaryColor = Color(0xFF1B4332);      // Rich Dark Green
  static const Color primaryDark = Color(0xFF123524);       // Deeper Dark Green
  
  // Premium Gold (Luxury Accent)
  static const Color goldColor = Color(0xFFD4A017);         // Gold
  static const Color goldLight = Color(0xFFC89B3C);        // Muted Luxury Gold
  
  // Backgrounds
  static const Color backgroundColor = Color(0xFF081C15);   // Deep Forest Black
  static const Color surfaceCard = Color(0xFF0F2A20);       // Secondary Green Card
  static const Color surfaceCardLight = Color(0xFF16352A);  // Tertiary Surface
  static const Color navyAccent = Color(0xFF14213D);        // Deep Navy Blend

  // Typography
  static const Color textPrimary = Color(0xFFE9E5D6);       // Soft Beige (Primary)
  static const Color textSecondary = Color(0xFFA8B1A6);     // Muted Sage
  static const Color textMuted = Color(0xFF6E746D);         // Dark Sage
  static const Color mutedOlive = Color(0xFF5F6F52);       // Secondary Accent Olive

  // Status Colors
  static const Color errorColor = Color(0xFF7B2A2A);        // Muted Deep Red
  static const Color successColor = Color(0xFFD4A017);      // Using Gold for success
  static const Color secondaryColor = Color(0xFFD4A017);    // Gold as secondary
  static const Color accentColor = goldColor;               // Alias for backward compatibility

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryColor, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [goldColor, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient luxuryGradient = LinearGradient(
    colors: [primaryDark, navyAccent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Shadows ──────────────────────────────────────────────────────────
  static List<BoxShadow> goldShadow = [
    BoxShadow(
      color: goldColor.withValues(alpha: 0.15),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  // ── Sizing ────────────────────────────────────────────────────────────
  static const double borderRadiusSm = 12.0;
  static const double borderRadiusMd = 16.0;
  static const double borderRadiusLg = 24.0;
  static const double borderRadiusXl = 32.0;

  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  // ── Durations ─────────────────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 300);
  static const Duration animationMedium = Duration(milliseconds: 500);
  static const Duration animationSlow = Duration(milliseconds: 900);
  static const Duration splashDuration = Duration(seconds: 3);
}
