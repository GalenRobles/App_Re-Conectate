import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart'; // Importante para kDebugMode
import 'package:app/app_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //crashlist
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 🚀 ACTIVACIÓN CONDICIONAL DE APP CHECK 🚀
  if (kDebugMode) {
    // 1. MODO DEBUG (Pruebas Locales con 'flutter run')
    // Usa el Proveedor de Depuración para evitar el error 403 en emuladores.
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  } else {
    // 2. MODO RELEASE (Producción o builds firmados)
    // Usa Play Integrity para la seguridad estricta.
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  }

  runApp(
    const ProviderScope(
      child: AppWidget(),
    ),
  );
}