import 'package:flutter/material.dart';

class AppColors {
  // Brand Luxury Accents
  static const Color primary = Color(0xFFC5A059); // Champagne Gold
  static const Color primaryLight = Color(0xFFE5C578);
  static const Color primaryDark = Color(0xFF9E7B35);
  static const Color primarySubtle = Color(0x26C5A059);

  // Dark Luxury Palette
  static const Color background = Color(0xFF0D0E12); // Deep Obsidian
  static const Color surface = Color(0xFF15171D); // Rich Card Surface
  static const Color surfaceElevated = Color(0xFF1E212B);
  static const Color surfaceHighlight = Color(0xFF262B36);
  static const Color border = Color(0xFF2B2F3B);
  static const Color borderSubtle = Color(0xFF1F232D);

  // Light Palette (for contrast elements & badges)
  static const Color linen = Color(0xFFF7F5F0);
  static const Color cream = Color(0xFFEFECE6);

  // Text Colors
  static const Color textPrimary = Color(0xFFF7F8FA);
  static const Color textSecondary = Color(0xFFA1A7B5);
  static const Color textMuted = Color(0xFF6B7280);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE5C578), Color(0xFFC5A059), Color(0xFF9E7B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1C1F28), Color(0xFF14161C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroOverlayGradient = LinearGradient(
    colors: [
      Colors.transparent,
      Color(0x660D0E12),
      Color(0xF00D0E12),
      Color(0xFF0D0E12),
    ],
    stops: [0.0, 0.4, 0.8, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
