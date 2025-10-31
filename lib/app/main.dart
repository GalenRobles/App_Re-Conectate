import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_widget.dart';

// 2. Importa tus opciones de Firebase (esto es si usas el 'FlutterFire CLI')
// import 'firebase_options.dart';

void main() async {
  // 3. Asegura que todos los 'bindings' de Flutter estén listos
  // Necesario antes de llamar a Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Inicializa Firebase
  // Debes descomentar la línea de 'firebase_options.dart' si
  // ya configuraste Firebase en tu proyecto.
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // 5. ¡EL PASO CLAVE DE RIVERPOD!
  // Envolvemos toda la app en un 'ProviderScope'.
  // Esto es lo que "enciende" Riverpod y permite que
  // todos tus widgets puedan 'leer' los providers.
  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}