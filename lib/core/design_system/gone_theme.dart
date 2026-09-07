import 'package:flutter/material.dart';

abstract final class GoneColors {
  static const primary = Color(0xFF5B8DEF);
  static const deepNavy = Color(0xFF1F2937);
  static const softBlue = Color(0xFFEAF1FF);
  static const success = Color(0xFF34C77B);
  static const warning = Color(0xFFFFB547);
  static const error = Color(0xFFFF5A5F);
  static const gray50 = Color(0xFFF8F9FB);
  static const gray100 = Color(0xFFF1F3F5);
  static const gray300 = Color(0xFFDDE1E6);
  static const gray500 = Color(0xFF98A0AA);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF667085);
}

abstract final class GoneTheme {
  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: GoneColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        fontFamily: 'Roboto',
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GoneColors.primary, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GoneColors.error),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: GoneColors.error, width: 2),
        ),
      ),
    );
  }
}
