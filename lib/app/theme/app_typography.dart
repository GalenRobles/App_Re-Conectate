import 'package:flutter/material.dart';
import 'package:app/app/theme/app_colors.dart'; // Importamos nuestros colores

/// Define los estilos de texto (tipografía) de la app.
class AppTypography {
  AppTypography._(); // Constructor privado

  /// El 'TextTheme' principal que usará la app.
  static const TextTheme mainTextTheme = TextTheme(
    // --- Títulos ---
    // Para títulos grandes (ej. "RE-CONECTATE")
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryRed,
      fontFamily: 'Oswald', // (Cuando la tengas)
    ),

    // --- Cuerpo de Texto ---
    // Para texto normal (ej. descripciones de cursos)
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
       fontFamily: 'Oswald',
    ),

    // Para texto secundario (ej. "Ingresa tu correo...")
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
      fontFamily: 'Oswald',
    ),

    // --- Botones ---
    // Para el texto dentro de los botones
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.white, // Asumimos texto blanco en botones
       fontFamily: 'Oswald',
    ),
  );
}