import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A modern, high-contrast dark theme with vibrant emerald/teal accents,
/// subtle gradients, and glass-like surfaces.
class AppTheme {
  static const primarySeed = Color(0xFF00E5A8); // emerald-teal
  static const surfaceTint = Color(0xFF0E1B14); // deep green-ish black

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: primarySeed,
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0B0F0E),
      canvasColor: const Color(0xFF0B0F0E),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        base.textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.04),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        surfaceTintColor: Colors.transparent,
      ),
      listTileTheme: const ListTileThemeData(iconColor: Colors.white70),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primarySeed, width: 1.2),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primarySeed,
        foregroundColor: Colors.black,
        shape: StadiumBorder(),
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: Color(0xFF043B2F),
        labelTextStyle: MaterialStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      dividerColor: Colors.white.withOpacity(0.06),
    );
  }

  /// Universal gradient used for headers/hero sections.
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0A2F25), Color(0xFF08251D), Color(0xFF071B16)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00E5A8), Color(0xFF04BFA3), Color(0xFF0AA08D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
