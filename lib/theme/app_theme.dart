import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary =
  Color(0xFF3157D5);

  static const Color secondary =
  Color(0xFF14B8A6);

  static const Color background =
  Color(0xFFF5F7FB);

  static const Color darkText =
  Color(0xFF172033);

  static const Color greyText =
  Color(0xFF697386);

  static const Color border =
  Color(0xFFE4E8F0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),

    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: darkText,
    ),

    inputDecorationTheme:
    InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: border,
        ),
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: border,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: primary,
          width: 2,
        ),
      ),
    ),
  );
}