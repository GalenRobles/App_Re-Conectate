import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Asegúrate de importar el servicio para poder usar el método de verificación
import 'package:reconectate/services/email_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  // El email es obligatorio para saber qué OTP buscar en Firestore
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final EmailService _emailService = EmailService();
  bool _isLoading = false;
  final Color primaryColor = const Color(0xFFD32F2F); // Color principal

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN CLAVE: VERIFICAR OTP ---
  Future<void> _verifyOtp() async {
    final enteredOtp = _otpController.text.trim();

    if (enteredOtp.length < 6) { // Asumiendo OTP de 6 dígitos
      _showSnackbar('El código debe tener 6 dígitos.', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _showSnackbar('Verificando código...', Colors.blue);

    try {
      // 1. LLAMAR AL SERVICIO. Verifica el email y el OTP en Firestore.
      final isVerified = await _emailService.verifyOtp(widget.email, enteredOtp);

      if (isVerified) {
        // 2. ÉXITO: El código es correcto y no ha expirado.
        if (mounted) {
          // Si el código es correcto, navega a la pantalla de Home
          // Nota: Aquí deberías terminar el proceso de registro, por ejemplo, creando el usuario en Firebase Auth.
          context.go('/home');
          _showSnackbar('¡Verificación exitosa! Bienvenido/a.', Colors.green);
        }
      } else {
        // 3. FALLO: El código es incorrecto o ha expirado.
        _showSnackbar('Código incorrecto o expirado. Inténtalo de nuevo.', Colors.red);
      }
    } catch (e) {
      // Manejo de errores de red o base de datos
      _showSnackbar('Error al verificar: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de Código', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingresa el Código',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 10),
            Text(
              'Hemos enviado un código de 6 dígitos a su correo electrónico:\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Campo de entrada de OTP
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6, // Máximo 6 dígitos
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Código OTP',
                hintText: 'Ej: 123456',
                counterText: '', // Oculta el contador de caracteres
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Botón de Verificación
            _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
              child: const Text('Verificar Código', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),

            // Botón para reenviar (Lógica opcional, no implementada aquí)
            TextButton(
              onPressed: () {
                // TODO: Implementar la lógica para reenviar el correo (reutilizando _emailService.sendOtpEmail(widget.email))
                _showSnackbar('Funcionalidad de reenvío pendiente.', Colors.orange);
              },
              child: Text(
                '¿No recibiste el código? Reenviar.',
                style: TextStyle(color: primaryColor.withOpacity(0.8), decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}