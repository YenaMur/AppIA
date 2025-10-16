import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),

    // Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderRadiusMedium),
        ),
        minimumSize: const Size(double.infinity, AppValues.buttonHeight),
      ),
    ),

    // Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMedium,
        vertical: AppValues.paddingSmall,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.textHint),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textHint),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),

    // Textos globales
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 28,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),

    // Iconos
    iconTheme: const IconThemeData(
      color: AppColors.primary,
      size: AppValues.iconSizeMedium,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
  );
}
