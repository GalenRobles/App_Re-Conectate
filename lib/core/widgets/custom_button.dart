// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  /// El texto que se mostrará dentro del botón.
  final String text;

  /// La función que se ejecutará al presionar el botón.
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Usamos un ElevatedButton.
    // 2. ¡NO le damos estilo! ¿Por qué?
    // 3. Porque nuestro 'AppTheme.lightTheme' (en app_theme.dart)
    //    ya tiene un 'elevatedButtonTheme' que le da
    //    automáticamente el color rojo, los bordes redondeados
    //    y el tamaño de fuente correcto.
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );

    // NOTA: Si quisieras un botón AMARILLO (como el de tu diseño)
    // podrías hacer esto:
    // return ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: AppColors.primaryYellow,
    //     foregroundColor: AppColors.primaryText, // Texto negro
    //   ),
    //   onPressed: onPressed,
    //   child: Text(text),
    // );
  }
}