import 'package:flutter/material.dart';

/// Tunisia-inspired palette — Sidi Bou Said blue, harissa, saffron, olive, terracotta.
class AppColors {
  /// Warm whitewash
  static const background = Color(0xFFFAF7F2);
  static const backgroundWarm = Color(0xFFF5EDE3);

  // Pastel card fills
  static const saffron = Color(0xFFF2D491);
  static const terracotta = Color(0xFFEDCEB8);
  static const mediterranean = Color(0xFFB8D8EA);
  static const olive = Color(0xFFCED9B0);
  static const mint = Color(0xFFD4E8DC);

  // Legacy aliases
  static const lavender = saffron;
  static const sage = olive;
  static const pink = terracotta;
  static const blue = mediterranean;
  static const yellow = Color(0xFFEDE4B0);

  // Signature accents
  static const sidiBlue = Color(0xFF2B7CB8);
  static const sidiBlueLight = Color(0xFF9DC8E8);
  static const harissa = Color(0xFFC0392B);
  static const harissaSoft = Color(0xFFE8A090);
  static const saffronDeep = Color(0xFFC9952B);
  static const terracottaDeep = Color(0xFFB8654A);
  static const mediterraneanDeep = Color(0xFF2B7CB8);
  static const oliveDeep = Color(0xFF6B8E4E);

  static const motifInk = Color(0xFF8B6914);
  static const motifBlue = Color(0xFF2B7CB8);

  static const cardPalette = [
    saffron,
    terracotta,
    mediterranean,
    olive,
    mint,
    yellow,
  ];

  static const surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, backgroundWarm],
  );

  // Dark mode
  static const darkBackground = Color(0xFF121820);
  static const darkBackgroundWarm = Color(0xFF1A2230);
  static const darkSurface = Color(0xFF1E2836);
  static const darkCard = Color(0xFF263244);

  static const darkSurfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBackground, darkBackgroundWarm],
  );
}
