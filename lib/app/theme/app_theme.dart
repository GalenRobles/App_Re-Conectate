import 'package:flutter/material.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/app/theme/app_typography.dart';

/// Define el tema principal de la aplicación.
class AppTheme {
  AppTheme._(); // Constructor privado

  /// El tema claro (Light Theme) para la app.
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // 1. COLORES
    primaryColor: AppColors.primaryRed,
    scaffoldBackgroundColor: AppColors.appBackground, // <-- ✅ Correcto
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryRed,
      background: AppColors.appBackground,
    ),
    // 2. TIPOGRAFÍA
    textTheme: AppTypography.mainTextTheme,

    // 3. WIDGETS (¡Aquí está la magia!)

    // --- Tema para ElevatedButton (Tus botones rojos) ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white, // Color del texto
        textStyle: AppTypography.mainTextTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Tu diseño usa bordes redondeados
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50), // Ancho completo por defecto
      ),
    ),

    // --- Tema para Campos de Texto (Tus formularios) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder( // Borde por defecto
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.textFieldBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder( // Borde cuando está habilitado
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.textFieldBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder( // Borde cuando tiene el foco
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
      ),
    ),
  );
}