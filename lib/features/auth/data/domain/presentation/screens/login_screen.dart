import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart'; // NECESARIO para el botón de Google

// Importa los servicios clave
import 'package:reconectate/providers/auth_login_notifier.dart';
import 'package:reconectate/providers/auth_providers.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Es una buena práctica usar controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login google
  Future<UserCredential?>  login() async{
  try{
    final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

    if(googleuser == null){
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleuser.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);


  }catch(e){
    return null;
  }

  }



  // Y un GlobalKey para el formulario si vas a usar validación
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------
  // LÓGICA DE LOGIN CON EMAIL/PASS (COMPLETA)
  // -------------------------------------------------------------------
  void _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(authNotifierProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      await notifier.signInWithEmail(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String message = 'Error de Login.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Correo o contraseña incorrectos.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    }
  }

  // -------------------------------------------------------------------
  // LÓGICA DE LOGIN CON GOOGLE (Placeholder para Lira/Edwin)
  // -------------------------------------------------------------------
  void _loginWithGooglePlaceholder() {
    // Tarea reasignada a Lira/Edwin: Implementar la llamada a authNotifier.signInWithGoogle()
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de Google pendiente por implementar.')),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Observa el estado de carga para deshabilitar botones
    final isLoading = ref.watch(authNotifierProvider);
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
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tus datos para iniciar sesión',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 40),

                  // 3. Campos de texto
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

                  // --- ENLACE DE RECUPERACIÓN DE CONTRASEÑA ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text('¿Olvidaste la contraseña?'),
                      onPressed: () {
                        context.push('/forgotPassword');
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 4. Botón de Ingresar
                  CustomButton(
                    text: isLoading ? 'Cargando...' : 'Ingresar',
                    onPressed: isLoading ? null : _loginWithEmail, // Conectado a la lógica
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
                    onPressed: () async{

                      final userCredential = await login();

                      if (userCredential != null) {
                        print("¡Inicio de sesión exitoso! Usuario: ${userCredential.user?.displayName}");
                      } else {
                        print(
                            "El inicio de sesión con Google falló o fue cancelado.");
                      }

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
