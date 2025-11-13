import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_widget.dart';

// 1. NUEVO - Importa el paquete de App Check
import 'package:firebase_app_check/firebase_app_check.dart';

// import 'firebase_options.dart'; // (Descomenta si usas FlutterFire CLI)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // (Descomenta si usas FlutterFire CLI)
  );

  // 2. NUEVO - Activa App Check en modo Play Integrity (Producción)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  // Envolvemos toda la app en un 'ProviderScope'
  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}