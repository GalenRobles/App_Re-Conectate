import 'package:flutter/material.dart';

/// Define la paleta de colores central de la aplicación.
///
/// Usamos un constructor privado `_()` para que esta clase
/// no pueda ser instanciada. Se usa solo estáticamente.
class AppColors {
  AppColors._(); // <-- Mantenemos tu excelente estructura

  // --- Colores Primarios (Basados en tu Figma) ---

  /// El rojo/vino principal usado en botones y logos.
  /// HEX: #D62837 (El valor que tenías)
  static const Color primaryRed = Color(0xFFD62837);

  /// El color amarillo/dorado de los botones secundarios y barra de carga.
  /// HEX: #EFC760 (Confirmado)
  static const Color primaryYellow = Color(0xFFEFC760);


  // --- Colores de Fondo ---

  /// ¡ACTUALIZADO! El color de fondo principal de la app (el "hueso").
  /// HEX: #EDEAE0 (El que me pediste para el fondo de pantalla)
  static const Color appBackground = Color(0xFFEDEAE0);

  /// Un color sutil para el fondo de la barra de carga (del splash).
  /// HEX: #DCD9D1 (Un tono más oscuro que el fondo para contraste)
  static const Color loadingBarBackground = Color(0xFFDCD9D1);


  // --- Colores Neutrales y de Texto ---

  /// El color de texto principal (negro).
  /// HEX: #000000 (El valor que tenías)
  static const Color textPrimary = Color(0xFF000000);

  /// Color de texto secundario (grises).
  /// HEX: #757575 (El valor que tenías)
  static const Color textSecondary = Color(0xFF757575);

  /// Color para los bordes de los campos de texto.
  /// HEX: #E0E0E0 (El valor que tenías, corregí el typo 'textFielBorder')
  static const Color textFieldBorder = Color(0xFFE0E0E0);

  /// Blanco puro.
  /// HEX: #FFFFFF
  static const Color white = Color(0xFFFFFFFF);
}

