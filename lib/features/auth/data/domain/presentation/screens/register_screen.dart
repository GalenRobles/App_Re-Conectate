import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';
import 'package:reconectate/features/auth/data/domain/presentation/screens/otp_verification_screen.dart';

// Importa los servicios clave
import 'package:reconectate/providers/auth_login_notifier.dart';
import 'package:reconectate/providers/auth_providers.dart';
import 'package:reconectate/services/email_service.dart'; // <--- 1. IMPORTADO

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 1. Controladores (Añadido _confirmPasswordController)
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final EmailService _emailService = EmailService(); // <--- 2. INICIALIZADO
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // 2. Dispose (Añadido _confirmPasswordController)
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Lógica de Registro (sin cambios, ya que la validación se hace en el Form)
  void _handleRegistration() async {
    // 1. Validar el formulario (¡Ahora valida también la confirmación!)
    if (!_formKey.currentState!.validate()) {
      print('DEBUG-0.5: Falló la validación del formulario.');
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final firestoreService = ref.read(firestoreServiceProvider);

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String nombre = _nameController.text.trim();
    final String apellido = _lastNameController.text.trim();

    // Mostrar un Snackbar genérico de "Registrando..."
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creando cuenta y enviando código...'), backgroundColor: Colors.blue)
    );

    try {
      print('DEBUG-1: Iniciando autenticación...');

      // 1. Crear usuario en Firebase Auth
      final userCredential = await authNotifier.signUpWithEmail(
        email: email,
        password: password,
      );

      print('DEBUG-2: Autenticación EXITOSA! UID: ${userCredential.user!.uid}');

      // 2. Crear perfil en Firestore
      await firestoreService.createUserProfile(
        userId: userCredential.user!.uid,
        email: email,
        nombre: nombre,
        apellido: apellido,
      );

      print('DEBUG-3: Escritura en Firestore EXITOSA!');

      // 3. Enviar el correo OTP
      print('DEBUG-3.5: Iniciando envío de correo OTP...');
      // Usamos el argumento 'name' en el servicio para que la función tenga más datos
      final bool emailSent = await _emailService.sendOtpEmail(
        email: email,
        name: nombre, // Pasamos el nombre para que la Cloud Function lo use en el email
      );

      if (emailSent) {
        print('DEBUG-4: Correo enviado. Navegando a verificación.');

        // Limpiar el Snackbar antes de navegar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // 🚨 NAVEGACIÓN CORREGIDA: SOLO UNA LLAMADA Y DENTRO DEL BLOQUE 'emailSent'
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/verific', extra: email);
        });

      } else {
        // El correo falló (Error en Cloud Function, Nodemailer, etc.)
        print('DEBUG-4: FALLO en el envío del correo OTP. Revisa la consola.');

        // Muestra un error al usuario y NO navega
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al enviar el código de verificación. Puede que la cuenta se haya creado sin verificar.'), backgroundColor: Colors.red)
        );
      }

      // 🚨 IMPORTANTE: SE ELIMINÓ LA LLAMADA DUPLICADA A context.go('/verific') que no pasaba el 'extra'

    } on FirebaseAuthException catch (e) {
      String message = 'Error de Autenticación.';
      if (e.code == 'email-already-in-use') {
        message = 'Ese correo ya está registrado. Inicia sesión.';
      } else if (e.code == 'weak-password') {
        message = 'La contraseña debe tener 6 caracteres o más.';
      } else if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico es incorrecto.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // --- 1. LOGO CENTRADO ARRIBA ---
                  Center( // Usamos Center para centrar el logo y los títulos
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png', // [cite: uploaded:galenrobles/app_re-conectate/App_Re-Conectate-RegistroLogin/assets/images/logo.png]
                          height: 120,
                        ),
                        const SizedBox(height: 20),
                        // Título de la pantalla
                        Text('¡Crea tu Cuenta!', textAlign: TextAlign.center, style: textTheme.headlineMedium),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // --- CAMPOS DE REGISTRO ---
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Nombre(s)',
                    keyboardType: TextInputType.text,
                    validator: (v) => v!.isEmpty ? 'Ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _lastNameController,
                    hintText: 'Apellido(s)',
                    keyboardType: TextInputType.text,
                    validator: (v) => v!.isEmpty ? 'Ingresa tu apellido' : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Ingresa tu correo' : null,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Contraseña (mín. 6 caracteres)',
                    obscureText: true,
                    validator: (v) => v!.length < 6 ? 'Contraseña muy corta' : null,
                  ),
                  const SizedBox(height: 15),

                  // 3. CAMPO AÑADIDO: Confirmar Contraseña
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirmar Contraseña',
                    obscureText: true,
                    // 4. LÓGICA DE VALIDACIÓN AÑADIDA
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'Confirma tu contraseña';
                      }
                      if (v != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // 4. Botón de Registro (sin cambios)
                  CustomButton(
                    text: isLoading ? 'Registrando...' : 'Registrarme',
                    onPressed: isLoading ? null : _handleRegistration,
                  ),
                  const SizedBox(height: 30),

                  // 5. Botón para ir a Login (sin cambios)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿Ya tienes cuenta?", style: textTheme.bodySmall),
                      TextButton(
                        child: const Text('Inicia Sesión'),
                        onPressed: () {
                          context.go('/login');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}