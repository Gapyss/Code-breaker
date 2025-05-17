import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors (based on the image)
  static const Color primaryColorLight =
      Color(0xFF8AB4F8); // Soft, desaturated blue (approx.)
  static const Color secondaryColorLight =
      Color(0xFF64B5F6); // Slightly brighter blue for accents
  static const Color textColorLight = Colors.black87;
  static const Color backgroundColorLight =
      Color(0xFFE0F2F7); // Very light blue/off-white (approx.)
  static const Color surfaceVariantLight = Colors.white;
  static const Color accentColorLight =
      Color(0xFF1E88E5); // Brighter blue for selection

  // Dark Theme Colors (can be adapted, using darker shades of the light theme for consistency)
  static const Color primaryColorDark = Color(0xFF5C6BC0);
  static const Color secondaryColorDark = Color(0xFF42A5F5);
  static const Color textColorDark = Colors.white70;
  static const Color backgroundColorDark = Color(0xFF303030);
  static const Color surfaceVariantDark = Color(0xFF424242);
  static const Color accentColorDark = Color(0xFF64B5F6);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColorLight,
      brightness: Brightness.light,
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      surfaceVariant: surfaceVariantLight,
      background: backgroundColorLight,
      onPrimary: textColorLight,
      onSecondary: textColorLight,
      onSurfaceVariant: textColorLight.withOpacity(0.8),
      onBackground: textColorLight.withOpacity(0.8),
      onTertiary: accentColorLight,
      // Using tertiary for the selected date color
      onTertiaryContainer: textColorLight,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16.0, color: textColorLight),
      titleLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: textColorLight),
      titleMedium: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w500, color: textColorLight),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorLight,
      foregroundColor: textColorLight,
      titleTextStyle: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.w500, color: textColorLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColorLight,
        backgroundColor: primaryColorLight,
        // Using the soft blue for the button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: textColorLight.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryColorLight.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: secondaryColorLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: textColorLight.withOpacity(0.3)),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceVariantLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColorDark,
      brightness: Brightness.dark,
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      surfaceVariant: surfaceVariantDark,
      background: backgroundColorDark,
      onPrimary: textColorDark,
      onSecondary: textColorDark,
      onSurfaceVariant: textColorDark.withOpacity(0.8),
      onBackground: textColorDark.withOpacity(0.8),
      onTertiary: accentColorDark,
      onTertiaryContainer: textColorDark,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16.0, color: textColorDark),
      titleLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: textColorDark),
      titleMedium: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w500, color: textColorDark),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorDark,
      foregroundColor: textColorDark,
      titleTextStyle: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.w500, color: textColorDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColorDark,
        backgroundColor: primaryColorDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: textColorDark.withOpacity(0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryColorDark.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: secondaryColorDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: textColorDark.withOpacity(0.3)),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceVariantDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );
}
