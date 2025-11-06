import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reconectate/core/widgets/custom_button.dart';
import 'package:reconectate/core/widgets/custom_text_field.dart';

// Importa tus providers centrales
import 'package:reconectate/providers/auth_providers.dart';
import 'package:reconectate/providers/auth_login_notifier.dart';


class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------
  // LÓGICA DE ENVÍO DE EMAIL DE RECUPERACIÓN
  // -------------------------------------------------------------------
  void _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String email = _emailController.text.trim();

    // Accede a los servicios que acabas de crear
    final resetPassword = ref.read(passwordResetProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier); // Para manejar el estado de carga

    try {
      // Activa el estado de carga manualmente si es necesario, aunque el notifier lo hace
      // Notifier ya maneja 'state = true' y 'false'

      await resetPassword(email: email);

      // ÉXITO: Muestra un mensaje y regresa a Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Enlace de recuperación enviado. Revisa tu correo.'),
          backgroundColor: Colors.green,
        ),
      );
      // Navega de vuelta a Login para que el usuario pueda usar el enlace
      context.go('/login');

    } on FirebaseAuthException catch (e) {
      // Captura y muestra errores específicos (ej. correo no registrado)
      String message = 'No se pudo enviar el correo.';
      if (e.code == 'user-not-found') {
        message = 'No existe una cuenta registrada con ese correo.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      // Captura otros errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa el estado de carga para deshabilitar el botón
    final isLoading = ref.watch(authNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    '¿Olvidaste tu Contraseña?',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),

                  // Campo de Correo
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v!.isEmpty ? 'Ingresa tu correo' : null,
                  ),
                  const SizedBox(height: 40),

                  // Botón de Enviar
                  CustomButton(
                    text: isLoading ? 'Enviando...' : 'Enviar Enlace',
                    onPressed: isLoading ? null : _handlePasswordReset,
                  ),
                  const SizedBox(height: 20),

                  // Botón de Regresar
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('Volver a Iniciar Sesión'),
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