import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';

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
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final EmailService _emailService = EmailService(); // <--- 2. INICIALIZADO
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Lógica de Registro (AÑADIDA LLAMADA A SEND OTP)
  void _handleRegistration() async {
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

      // Paso 1: Crear el usuario en Firebase
      final userCredential = await authNotifier.signUpWithEmail(
        email: email,
        password: password,
      );

      print('DEBUG-2: Autenticación EXITOSA! UID: ${userCredential.user!.uid}');

      // Paso 2: Crear el perfil en Firestore
      await firestoreService.createUserProfile(
        userId: userCredential.user!.uid,
        email: email,
        nombre: nombre,
        apellido: apellido,
      );

      print('DEBUG-3: Escritura en Firestore EXITOSA!');

      // ----------------------------------------------------
      // PASO CRUCIAL AÑADIDO: ENVIAR EL CORREO OTP
      // ----------------------------------------------------
      print('DEBUG-3.5: Iniciando envío de correo OTP...');
      final bool emailSent = await _emailService.sendOtpEmail(email);

      if (emailSent) {
        print('DEBUG-4: Correo enviado. Navegando a verificación.');

        // Limpiar el Snackbar antes de navegar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Paso 4: Navegar si el envío de correo fue exitoso
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/verific', extra: email);
        });

      } else {
        // El correo falló (error de EmailJS, credenciales, etc.)
        print('DEBUG-4: FALLO en el envío del correo OTP. Revisa la consola.');

        // Muestra un error al usuario y NO navega
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al enviar el código de verificación. Revisa la configuración del servidor de correo.'), backgroundColor: Colors.red)
        );

        // Opcional: Podrías considerar eliminar el usuario recién creado si el envío de OTP es crítico.
        // await userCredential.user?.delete();
      }


    } on FirebaseAuthException catch (e) {
      print('DEBUG-5: FALLO AUTH - Código: ${e.code}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fallo en la autenticación: ${e.message}'), backgroundColor: Colors.red)
      );
    } catch (e) {
      print('DEBUG-6: FALLO GENERAL - Causa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error inesperado.'), backgroundColor: Colors.red)
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
                  Text('¡Crea tu Cuenta!', textAlign: TextAlign.center, style: textTheme.headlineMedium),
                  const SizedBox(height: 30),

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

                  // Confirmar Contraseña
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirmar Contraseña',
                    obscureText: true,
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

                  // Botón de Registro
                  CustomButton(
                    text: isLoading ? 'Registrando...' : 'Registrarme',
                    onPressed: isLoading ? null : _handleRegistration,

                  ),
                  const SizedBox(height: 30),

                  // Botón para ir a Login
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