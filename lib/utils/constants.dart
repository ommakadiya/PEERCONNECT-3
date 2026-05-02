import 'package:flutter/material.dart';

/// App-wide constants for theming, colors, and sizing.
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────────────
  static const String appName = 'PeerConnect';
  static const String appTagline = 'Connect. Collaborate. Grow.';
  static const String googleSignInWebClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  // ── Colors ────────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF0A1F0F);
  static const Color primaryColor = Color(0xFF0C4A23);
  static const Color secondaryColor = Color(0xFF1C6331);
  static const Color accentColor = Color(0xFFE4C56C);
  static const Color highlightColor = Color(0xFFC0A35A);
  static const Color surfaceDark = backgroundColor;
  static const Color surfaceCard = Color(0xFF1A2F1F);
  static const Color surfaceCardLight = Color(0xFF223727);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BCC0);
  static const Color textMuted = Color(0xFF8A857F);
  static const Color errorColor = Color(0xFFFF4757);
  static const Color successColor = Color(0xFF2ED573);

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, Color(0xFF0F2415), backgroundColor],
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
