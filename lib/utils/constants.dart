import 'package:flutter/material.dart';

/// App-wide constants for theming, colors, and sizing.
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────────────
  static const String appName = 'PeerConnect';
  static const String appTagline = 'Connect. Collaborate. Grow.';
  static const String googleSignInWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  // ── Colors ────────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF1B4332);
  static const Color primaryColor = Color(0xFF355E3B);
  static const Color secondaryColor = Color(0xFFCAA64D);
  static const Color accentColor = Color(0xFFCAA64D);
  static const Color highlightColor = Color(0xFFE5C36E);
  static const Color surfaceDark = Color(0xFF143024);
  static const Color surfaceCard = Color(0xFF244A37);
  static const Color surfaceCardLight = Color(0xFF355E3B);
  static const Color textPrimary = Color(0xFFFDF6E3);
  static const Color textSecondary = Color(0xFFD4CCB6);
  static const Color textMuted = Color(0xFFA6A495);
  static const Color errorColor = Color(0xFFFF4757);
  static const Color successColor = Color(0xFF2ED573);

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, surfaceDark, backgroundColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Sizing ────────────────────────────────────────────────────────────
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 20.0;
  static const double borderRadiusXl = 28.0;

  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  // ── Durations ─────────────────────────────────────────────────────────
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 800);
  static const Duration splashDuration = Duration(seconds: 3);
}
