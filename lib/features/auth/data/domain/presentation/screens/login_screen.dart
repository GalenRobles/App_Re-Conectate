import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Es una buena práctica usar controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Y un GlobalKey para el formulario si vas a usar validación
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // Usamos SingleChildScrollView para evitar que el teclado tape los campos
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // 1. Logo de la Matrioska (¡Añadido!)
                  // Debes agregar tu imagen en una carpeta 'assets/images/'
                  // y declararla en pubspec.yaml
                  Image.asset(
                    'assets/images/logo.png', // Ajusta esta ruta
                    height: 120, // Ajusta el tamaño
                  ),
                  const SizedBox(height: 20),

                  // 2. Títulos (como los tenías)
                  Text(
                    'RE-CONECTATE',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium, // Usando tu tema
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tus datos para iniciar sesión',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall, // Usando tu tema
                  ),
                  const SizedBox(height: 40),

                  // 3. Campos de texto (usando nuestro widget)
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Ingresa tu correo',
                    keyboardType: TextInputType.emailAddress,
                    // TODO: Añadir validación desde core/utils/validators.dart
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),

                  // 4. Botón de Ingresar (como lo tenías)
                  CustomButton(
                    text: 'Ingresar', // Tu diseño usa 'Ingresar'
                    onPressed: () {
                      // TODO: Aquí va la lógica de login con Riverpod
                    },
                  ),
                  const SizedBox(height: 30),

                  // 5. Botones de Login
                  Text(
                    'O continuar con',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  SignInButton(
                    Buttons.Google,
                    text: "Continuar con Google",
                    onPressed: () {
                      // TODO: Aquí va la lógica de google_sign_in
                    },
                  ),
                  const SizedBox(height: 20),

                  // 6. Botón para ir a Registro (¡Muy importante!)
                  // Tu diseño no lo muestra, pero es fundamental para el flujo.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes cuenta?", style: textTheme.bodySmall),
                //button
                      TextButton(
                        child: const Text('Regístrate'),
                        onPressed: () {
                          // Usando el nuevo path
                          context.push('/registre');
                        },
                      ),
                          // Ejemplo con go_router: context.push('/register');


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
