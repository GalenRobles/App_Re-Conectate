import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';

// Importa los servicios clave
import 'package:reconectate/providers/auth_login_notifier.dart';
import 'package:reconectate/providers/auth_providers.dart';


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
  final _confirmPasswordController = TextEditingController(); // <-- AÑADIDO

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // 2. Dispose (Añadido _confirmPasswordController)
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // <-- AÑADIDO
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

    try {
      print('DEBUG-1: Iniciando autenticación...');

      final userCredential = await authNotifier.signUpWithEmail(
        email: email,
        password: password,
      );

      print('DEBUG-2: Autenticación EXITOSA! UID: ${userCredential.user!.uid}');

      await firestoreService.createUserProfile(
        userId: userCredential.user!.uid,
        email: email,
        nombre: nombre,
        apellido: apellido,
      );

      print('DEBUG-3: Escritura en Firestore EXITOSA! Navegando...');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/verific');
      });

    } on FirebaseAuthException catch (e) {
      print('DEBUG-4: FALLO AUTH - Código: ${e.code}');
      // ... (Manejo de errores)
    } catch (e) {
      print('DEBUG-5: FALLO GENERAL - Causa: $e');
      // ... (Manejo de errores)
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