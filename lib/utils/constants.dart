import 'package:flutter/material.dart';

/// App-wide constants for theming, colors, and sizing.
class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────────────
  static const String appName = 'GuardianNet';
  static const String appTagline = 'Safe, Simple, and Connected.';

  /// ⚠️ REQUIRED: Replace this with the Web Client ID from your Firebase project.
  /// How to get it:
  ///   1. Go to Firebase Console → peerconnect-16e19
  ///   2. Authentication → Sign-in method → Google → (expand)
  ///   3. Copy the "Web client ID" shown under "Web SDK configuration"
  static const String googleSignInWebClientId =
      '1071073494722-vgdqe9ph1le91km07lot74b7p2vohr1q.apps.googleusercontent.com';

  // ── Colors ────────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF1A1A1A); // Pure Black Background
  static const Color primaryColor = Color(0xFFD4AF37);    // Gold
  static const Color secondaryColor = Color(0xFFF3E8C9);  // Cream
  static const Color accentColor = Color(0xFFD4AF37);
  static const Color highlightColor = Color(0xFFF3E8C9);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceCard = Color(0xFF252525);     // Dark Grey Card
  static const Color surfaceCardLight = Color(0xFF2D2D2D);
  static const Color textPrimary = Color(0xFFF3E8C9);     // Cream Text
  static const Color textSecondary = Color(0xFFE0D5B7);   // Muted Cream
  static const Color textMuted = Color(0xFF7D7D7D);
  static const Color errorColor = Color(0xFFFF4757);
  static const Color successColor = Color(0xFFD4AF37);    // Gold for success too
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color creamColor = Color(0xFFF3E8C9);

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFB8962D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, Color(0xFF121212), backgroundColor],
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
