import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; // Asegúrate de tener 'http' en pubspec.yaml

class EmailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- CONFIGURACIÓN DE SENDGRID (¡REEMPLAZA ESTO!) ---
  // Obtén tu API Key de SendGrid (empieza por 'SG.').
  // ADVERTENCIA: Esta clave API está expuesta en el código fuente de tu app.
  // Es mejor usar una cuenta con permisos restringidos (Custom Access -> Mail Send).
  static const String _sendGridApiKey = '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';



  // Reemplaza con el email verificado que usas en SendGrid (ej: no-reply@tuapp.com)
  static const String _senderEmail = 'aplicacionreconectate@gmail.com';
  // ---------------------------------------------------

  final String _otpCollection = 'user_otps';
  final String _sendGridUrl = 'https://api.sendgrid.com/v3/mail/send';

  String _generateOtp() {
    final random = Random();
    // Genera un número entre 100000 y 999999
    return (random.nextInt(900000) + 100000).toString();
  }

  // --- 1. FUNCIÓN DE ENVÍO Y GUARDADO (Con SendGrid) ---
  // 🚨 CORRECCIÓN CLAVE: Acepta 'email' como parámetro con nombre y obligatorio.
  Future<bool> sendOtpEmail({required String email, required String name}) async {
    final recipientEmail = email; // Usamos el nombre 'recipientEmail' internamente para claridad
    final otpCode = _generateOtp();
    final expiresAt = DateTime.now().add(const Duration(minutes: 15));
    final expiresTime = expiresAt.toLocal().toString().substring(11, 16); // HH:MM

    // 1. GUARDAR la OTP en Firestore
    try {
      await _firestore.collection(_otpCollection).doc(recipientEmail).set({
        'email': recipientEmail,
        'otp': otpCode,
        'expiresAt': Timestamp.fromDate(expiresAt),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando OTP en Firestore: $e');
      }
      return false;
    }

    // 2. LLAMAR al endpoint de SendGrid
    final sendGridPayload = {
      'personalizations': [
        {
          'to': [
            {'email': recipientEmail}
          ],
          'dynamic_template_data': {
            // Estos son los nombres de las variables que debes usar en tu plantilla de SendGrid: {{otp_code}} y {{time}}
            'otp_code': otpCode,
            'time': expiresTime,
          }
        }
      ],
      'from': {
        'email': _senderEmail,
        'name': 'Equipo Re-Conectate'
      },
      // ATENCIÓN: Debes usar el 'template_id' de la plantilla dinámica que creaste en SendGrid.
      'template_id': 'd-2bc07a6f6c324bbe94a987e83e1b6eae' // <-- ¡REEMPLAZAR!
    };

    try {
      final response = await http.post(
        Uri.parse(_sendGridUrl),
        headers: {
          'Content-Type': 'application/json',
          // La clave API va aquí
          'Authorization': 'Bearer $_sendGridApiKey',
        },
        body: json.encode(sendGridPayload),
      );

      // 3. Verificar la respuesta de SendGrid
      // SendGrid devuelve 202 (Accepted) si el correo se puso en cola
      if (response.statusCode == 202) {
        if (kDebugMode) {
          print('Correo OTP enviado exitosamente con SendGrid! (Status: ${response.statusCode})');
        }
        return true;
      } else {
        // Fallo en SendGrid
        if (kDebugMode) {
          print('--- ERROR AL ENVIAR CORREO OTP (SendGrid) ---');
          print('Status Code: ${response.statusCode}');
          print('Cuerpo de la Respuesta: ${response.body}');
          print('-------------------------------------------');
        }
        // Eliminar la OTP de Firestore si el envío falló
        await _firestore.collection(_otpCollection).doc(recipientEmail).delete();
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error de red/conexión al llamar a SendGrid: $e');
      }
      // Eliminar la OTP de Firestore si el envío falló
      await _firestore.collection(_otpCollection).doc(recipientEmail).delete();
      return false;
    }
  }

  // --- 2. FUNCIÓN DE VERIFICACIÓN ---
  Future<bool> verifyOtp(String email, String enteredOtp) async {
    try {
      final docSnapshot = await _firestore.collection(_otpCollection).doc(email).get();

      if (!docSnapshot.exists) {
        if (kDebugMode) print('No se encontró OTP para este email.');
        return false;
      }

      final data = docSnapshot.data()!;
      final storedOtp = data['otp'] as String;
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();

      if (storedOtp == enteredOtp && expiresAt.isAfter(DateTime.now())) {
        if (kDebugMode) print('OTP verificada exitosamente.');

        // Éxito: Eliminar el documento para evitar la reutilización del código
        await _firestore.collection(_otpCollection).doc(email).delete();

        return true;
      } else {
        if (kDebugMode) {
          if (storedOtp != enteredOtp) {
            print('El código ingresado no coincide.');
          } else {
            print('El código ha expirado.');
          }
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error durante la verificación de OTP: $e');
      }
      return false;
    }
  }
}