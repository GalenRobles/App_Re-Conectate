// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// 1. IMPORTACIÓN CORREGIDA:
// Apuntamos a nuestro nuevo AppWidget
import 'package:reconectate/app/app_widget.dart';

void main() {
  // 2. TÍTULO CORREGIDO:
  // Ya no probamos un contador, solo que la app arranque
  testWidgets('App smoke test', (WidgetTester tester) async {

    // 3. WIDGET CORREGIDO:
    // Construimos AppWidget en lugar de MyApp
    await tester.pumpWidget(const AppWidget());

    // 4. PRUEBA CORREGIDA:
    // Verificamos que se muestre el texto de nuestra pantalla de inicio
    expect(find.text('¡Proyecto Iniciado!'), findsOneWidget);
  });
}