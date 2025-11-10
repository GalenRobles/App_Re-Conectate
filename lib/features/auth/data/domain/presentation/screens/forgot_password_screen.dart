import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NECESARIO para FirebaseAuthException
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
  // LÓGICA DE ENVÍO DE EMAIL DE RECUPERACIÓN (COMPLETA Y SEGURA)
  // -------------------------------------------------------------------
  void _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String email = _emailController.text.trim();

    // Accede a los servicios que creaste
    final resetPassword = ref.read(passwordResetProvider);
    // Usamos el notifier para el estado de carga
    final authNotifier = ref.read(authNotifierProvider.notifier);

    try {
      // 1. Ejecuta la función de envío de correo
      await resetPassword(email: email);

      // 2. ÉXITO (INDEPENDIENTEMENTE SI EL CORREO EXISTE O NO)
      // Este mensaje genérico evita que un atacante sepa si el correo está registrado.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Si el correo existe, el enlace de recuperación ha sido enviado.'),
          backgroundColor: Colors.green,
        ),
      );

      // 3. Navega de vuelta a Login después del éxito (simulado o real)
      context.go('/');
    } on FirebaseAuthException catch (e) {
      // 4. Captura errores de red, formato, o de Firebase (pero no user-not-found)
      String message = 'Error: No se pudo restablecer la contraseña.';

      if (e.code == 'invalid-email') {
        message = 'El formato del correo electrónico es incorrecto.';
      } else if (e.code == 'user-not-found') {
        // Por seguridad UX, si el error es 'user-not-found',
        // tratamos el error como éxito para no dar pistas.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Si el correo existe, el enlace de recuperación ha sido enviado.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      // Captura otros errores (ej. de conexión)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}'), backgroundColor: Colors.red),
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