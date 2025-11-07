import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:pinput/pinput.dart';

// Pantalla de destino de ejemplo
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text('¡Verificación Exitosa!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Bienvenido a RE-CONECTATE.', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({required this.email, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();

  // Endpoints del backend
  final String _apiUrlVerify = 'http://tu-servidor.com/api/verify-otp'; // <<< CAMBIA ESTO
  final String _apiUrlResend = 'http://tu-servidor.com/api/send-otp'; // <<< CAMBIA ESTO

  bool _isLoading = false;

  // Lógica del temporizador
  int _secondsRemaining = 60; // 60 segundos antes de poder reenviar
  Timer? _timer;
  bool _canResend = false;

  final Color primaryColor = const Color(0xFFD32F2F);

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel(); // Cancela el temporizador al salir
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _canResend = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      }
    });
  }

  // --- FUNCIÓN DE VERIFICACIÓN DE OTP ---
  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      _showSnackbar('El código debe tener 6 dígitos.', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrlVerify),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': widget.email,
          'otp': _otpController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Éxito: El código es correcto. Navegación a Home
        if (mounted) {
          _timer?.cancel(); // Detenemos el timer
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
          );
        }
      } else {
        // Error: OTP inválido o expirado
        final errorBody = json.decode(response.body);
        _showSnackbar(errorBody['message'] ?? 'Código OTP inválido o expirado.', Colors.red);
      }
    } catch (e) {
      _showSnackbar('Error de conexión al verificar: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- FUNCIÓN DE REENVÍO DE OTP ---
  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
    });

    _showSnackbar('Reenviando código...', Colors.grey);

    try {
      final response = await http.post(
        Uri.parse(_apiUrlResend),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': widget.email}),
      );

      if (response.statusCode == 200) {
        _showSnackbar('Nuevo código enviado con éxito a ${widget.email}', Colors.green);
        _startResendTimer(); // Vuelve a iniciar el temporizador
      } else {
        final errorBody = json.decode(response.body);
        _showSnackbar(errorBody['message'] ?? 'Error al reenviar el código.', Colors.red);
        setState(() { _canResend = true; }); // Permite volver a intentarlo si hay error
      }
    } catch (e) {
      _showSnackbar('Error de conexión al reenviar: $e', Colors.red);
      setState(() { _canResend = true; });
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Verificación de Cuenta',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Hemos enviado un código de 6 dígitos al correo:\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // Entrada de OTP (Pinput)
            Center(
              child: Pinput(
                controller: _otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: primaryColor),
                ),
                onCompleted: (pin) => _verifyOtp(), // Verifica automáticamente al completar
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Verificar Código'),
            ),

            const SizedBox(height: 20),

            // Texto y Botón de Reenvío
            Center(
              child: TextButton(
                onPressed: _canResend ? _resendOtp : null,
                child: Text(
                  _canResend
                      ? 'Reenviar Código'
                      : 'Puedes reenviar en $_secondsRemaining segundos',
                  style: TextStyle(
                    color: _canResend ? primaryColor : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}