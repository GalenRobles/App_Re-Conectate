import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otp_verification_screen.dart';
// NOTA: Si usas GoRouter, la configuración principal de rutas DEBE estar en tu MaterialApp o Router.
// Para este ejemplo, usaremos navegación estándar de Flutter (MaterialPageRoute) en la función _sendOtp.

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(),
    );
  }
}

// Convertimos a StatefulWidget para manejar el estado del formulario y la carga
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controladores para capturar los datos del formulario
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController(); // CRÍTICO para el OTP
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // URL del endpoint del backend para enviar el OTP
  final String _apiUrlSendOtp = 'http://tu-servidor.com/api/send-otp'; // <<< CAMBIA ESTO

  bool _isLoading = false;
  final Color primaryColor = const Color(0xFFD32F2F);
  final Color backgroundColor = const Color(0xFFF7F5F0);

  @override
  void dispose() {
    // Es importante liberar los recursos de los controladores
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN DE ENVÍO DE OTP Y REGISTRO ---
  Future<void> _sendOtpAndRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validación simple
    if (email.isEmpty || password.isEmpty || _nameController.text.isEmpty) {
      _showSnackbar('Por favor, completa todos los campos.', Colors.red);
      return;
    }
    if (password != _confirmPasswordController.text) {
      _showSnackbar('Las contraseñas no coinciden.', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Prepara el cuerpo de la petición con todos los datos de registro
      final response = await http.post(
        Uri.parse(_apiUrlSendOtp),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'lastName': _lastNameController.text,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito: El usuario se registró (pendiente de verificación) y se envió el correo.
        if (mounted) {
          _showSnackbar('OTP enviado. Revisa tu correo.', Colors.green);

          // 2. Navega a la pantalla de verificación, pasando el email.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(email: email),
            ),
          );

          // NOTA: Si usas GoRouter, reemplaza la navegación anterior por:
          // context.push('/verific', extra: email); // Asegúrate de configurar la ruta
        }
      } else {
        // Error del servidor (ej. correo ya registrado, error de envío de correo)
        final errorBody = json.decode(response.body);
        _showSnackbar(errorBody['message'] ?? 'Error de registro o envío de OTP.', Colors.red);
      }
    } catch (e) {
      // Error de red
      _showSnackbar('Error de conexión: Verifica tu red.', Colors.red);
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
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Widget auxiliar para construir los campos de texto
  Widget _buildInputField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller, // Asignar el controlador
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 1. Imagen
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Center(
                  // Usamos un icono genérico como fallback si 'assets/images/logo.png' no existe
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.person_add, size: 100, color: primaryColor), // Fallback
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Título principal: RE-CONECTATE
              Text(
                'RE-CONECTATE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.5,
                ),
              ),
              // 3. Subtítulo: Crea tu cuenta
              Text(
                'Crea tu cuenta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),

              // 4. Instrucción: Ingresa tu correo...
              const Text(
                'Ingresa tus datos para crear tu cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 5. Formulario de Campos de Texto (Ahora con controladores)
              _buildInputField(hintText: 'Nombre', controller: _nameController),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'Apellido', controller: _lastNameController),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'email@domain.com', controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'Contraseña', controller: _passwordController, obscureText: true),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'Confirma tu Contraseña', controller: _confirmPasswordController, obscureText: true),
              const SizedBox(height: 30),

              // 6. Botón "Continue"
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : ElevatedButton(
                  onPressed: _sendOtpAndRegister, // Llama a la nueva función de registro y envío de OTP
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 30),

              // 7. Texto legal/Términos y Condiciones
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By clicking continue, you agree to our ',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}