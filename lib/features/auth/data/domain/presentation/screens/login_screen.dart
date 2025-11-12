import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NECESARIO para manejar la excepción
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:reconectate/core/widgets/custom_button.dart'; //
import 'package:reconectate/core/widgets/custom_text_field.dart'; //

// Importa los servicios clave (AuthNotifier y Providers)
import 'package:reconectate/providers/auth_login_notifier.dart'; //
import 'package:reconectate/providers/auth_providers.dart'; //


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------
  // A) LÓGICA DE LOGIN CON EMAIL/PASS (Tu tarea)
  // -------------------------------------------------------------------
  void _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(authNotifierProvider.notifier); //
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Tu código de autenticación
      await notifier.signInWithEmail(email: email, password: password); //

      // ÉXITO: El AuthGate navega.
    } on FirebaseAuthException catch (e) {
      // Manejo de Errores Específicos
      String message = 'Error de Login.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Correo o contraseña incorrectos.';
      }
      else if(e.code=='invalid-email') {
        message = 'El formato del correo es invalido';
      }
      else if(e.code=='user-disabled'){
        message ='Esta cuenta ha sido deshabilitada. Contacta al soporte.';
      }
      else if(e.code=='too-many-requests'){
        message='Demasiados intentos';
      }
      else{
        message='Ocurrió un error desconocido durante el inicio de sesión. Intenta de nuevo.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrio un error inesperado, Revisa tu conexion a internet')),
      );
    }
  }

  // -------------------------------------------------------------------
  // B) LÓGICA DE LOGIN CON GOOGLE (Tarea finalizada por Lira)
  // -------------------------------------------------------------------
  void _loginWithGoogle() async {
    final notifier = ref.read(authNotifierProvider.notifier);
    try {
      // Llama a la función de Google Sign-In que implementaste en AuthNotifier
      await notifier.signInWithGoogle(); //
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Google Login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha el estado de carga para deshabilitar botones
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
                  const SizedBox(height: 60),

                  // 1. Logo
                  Image.asset(
                    'assets/images/logo.png', //
                    height: 120,
                  ),
                  const SizedBox(height: 20),

                  // 2. Títulos
                  Text('RE-CONECTATE', textAlign: TextAlign.center, style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Ingresa tus datos para iniciar sesión', textAlign: TextAlign.center, style: textTheme.bodySmall),
                  const SizedBox(height: 40),

                  // 3. Campos de texto
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Ingresa tu correo',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Ingresa tu correo' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? 'Ingresa tu contraseña' : null,
                  ),

                  // --- ENLACE DE RECUPERACIÓN DE CONTRASEÑA ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text('¿Olvidaste la contraseña?'),
                      onPressed: () {
                        // Navega a la pantalla de Recuperación (Tu tarea)
                        context.push('/forgotPassword');
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 4. Botón de Ingresar
                  CustomButton(
                    text: isLoading ? 'Cargando...' : 'Ingresar',
                    // Conexión al Login por Email/Pass
                    onPressed: isLoading ? null : _loginWithEmail,
                  ),
                  const SizedBox(height: 30),

                  // 5. Botones de Login (Google)
                  Text('O continuar con', textAlign: TextAlign.center, style: textTheme.bodySmall),
                  const SizedBox(height: 20),

                  SignInButton(
                    Buttons.Google,
                    text: isLoading ? 'Cargando...' : "Continuar con Google",
                    // Conexión al Login por Google
                    onPressed: isLoading ? null : _loginWithGoogle,
                  ),

                  const SizedBox(height: 20),

                  // 6. Botón para ir a Registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes cuenta?", style: textTheme.bodySmall),
                      TextButton(
                        child: const Text('Regístrate'),
                        onPressed: () {
                          context.push('/registre'); //
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