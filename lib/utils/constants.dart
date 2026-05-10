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
  // Primary Palette
  static const Color forestGreen = Color(0xFF1B4332);     // Deep Forest Green
  static const Color premiumGold = Color(0xFFC89B3C);     // Premium Gold
  static const Color warmBeige = Color(0xFFF5E9DA);       // Background Base
  static const Color richBrown = Color(0xFF7A5C45);       // Earth Tone
  static const Color navyBlue = Color(0xFF14213D);        // Professional Navy
  
  // Supporting Colors
  static const Color softCream = Color(0xFFFAF6F0);       // Main BG
  static const Color mutedOlive = Color(0xFF5F6F52);      // Icons/Inactive
  static const Color charcoal = Color(0xFF2D2D2D);        // Primary Text
  static const Color lightSand = Color(0xFFD8C3A5);       // Disabled/Borders
  
  // Role-based colors (Mapped for Dark Theme)
  static const Color backgroundColor = Color(0xFF0B1222); // Deep Cinematic Navy
  static const Color primaryColor = forestGreen;
  static const Color secondaryColor = premiumGold;
  static const Color accentColor = premiumGold;
  static const Color surfaceCard = Color(0xFF161E2E);     // Dark Surface
  static const Color surfaceCardLight = Color(0xFF1F2937); 
  static const Color textPrimary = warmBeige;             // Warm Beige text for contrast
  static const Color textSecondary = Color(0xFF94A3B8);   // Muted Slate
  static const Color textMuted = Color(0xFF64748B);       
  static const Color errorColor = Color(0xFFF87171);      
  static const Color successColor = forestGreen;

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [forestGreen, Color(0xFF123524)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4A017), premiumGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient navyGradient = LinearGradient(
    colors: [Color(0xFF1E2A38), navyBlue],
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
