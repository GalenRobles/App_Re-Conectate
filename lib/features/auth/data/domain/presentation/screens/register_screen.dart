import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';
import 'package:reconectate/providers/auth_login_notifier.dart';
import 'package:reconectate/providers/auth_providers.dart';


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

  void _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final firestoreService = ref.read(firestoreServiceProvider);

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String nombre = _nameController.text.trim();
    final String apellido = _lastNameController.text.trim();

    try {
      final userCredential = await authNotifier.signUpWithEmail(
        email: email,
        password: password,
      );

      await firestoreService.createUserProfile(
        userId: userCredential.user!.uid,
        email: email,
        nombre: nombre,
        apellido: apellido,
      );

      // ÉXITO: Navegación ocurre vía AuthGate
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/verific');
      });

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
                // Alineación principal: centramos todos los elementos
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

                  // --- 2. CAMPOS DE TEXTO (Alineados a Stretch por el Column) ---
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

                  // 3. Botón de Registro
                  CustomButton(
                    text: isLoading ? 'Registrando...' : 'Registrarme',
                    onPressed: isLoading ? null : _handleRegistration,
                  ),
                  const SizedBox(height: 30),

                  // 4. Botón para ir a Login
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