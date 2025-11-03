import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegistrationScreen(),
      // Puedes definir el tema aquí para que el color principal afecte los botones, etc.
      // theme: ThemeData(
      //   primaryColor: const Color(0xFFD32F2F),
      //   elevatedButtonTheme: ElevatedButtonThemeData(...)
      // ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  // El color principal de la aplicación (rojo)
  final Color primaryColor = const Color(0xFFD32F2F);
  // El color de fondo claro (beige/crema)
  final Color backgroundColor = const Color(0xFFF7F5F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        // Usamos SingleChildScrollView para que el contenido sea desplazable
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            // Centra todos los widgets horizontalmente
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 1. Imagen (Simulada con un icono grande y color)
              // NOTA: Para usar la imagen real de la muñeca, necesitarías
              // agregar el archivo de imagen a la carpeta 'assets' de tu proyecto.
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // Simulando la forma y el color de la ilustración
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Center(
                  // Usamos un icono genérico para simular la ilustración sin tener el archivo
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120, // Ajusta el tamaño

                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Título principal: RE-CONECTATE
              Text(
                'RE-CONECTATE',
                style: TextStyle(
                  fontSize: 20,
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
                'Ingresa tu correo para iniciar sesion', // Parece ser un error en el texto original, que dice 'iniciar sesion' en una pantalla de 'crear cuenta'. Mantenemos el texto de la imagen.
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // 5. Formulario de Campos de Texto
              _buildInputField(hintText: 'Nombre'),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'Apellido'),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'email@domain.com', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'Contraseña', obscureText: true),
              const SizedBox(height: 15),
              _buildInputField(hintText: 'Confirma tu Contraseña', obscureText: true),
              const SizedBox(height: 30),

              // 6. Botón "Continue"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // 💡 Aquí cambiamos el `debugPrint` por la navegación.
                  onPressed: () {
                    // Importa 'package:go_router/go_router.dart'
                    // Usa context.go() para navegar a la siguiente ruta.
                    // Esto reemplaza la pila de navegación, ideal para avanzar en un flujo.
                    context.push('/verific');

                    // Alternativamente, puedes usar:
                    // context.push('/registro_completo');
                    // Si quieres mantener la pantalla actual en la pila para poder volver.

                    // Si usas rutas con nombre:
                    // context.goNamed('registroCompletoRouteName');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Fondo rojo
                    foregroundColor: Colors.white, // Texto blanco
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
                        // Aquí podrías agregar un GestureRecognizer para el onTap
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        // Aquí podrías agregar un GestureRecognizer para el onTap
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

  // Widget auxiliar para construir los campos de texto
  Widget _buildInputField({
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para los campos
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          // Sombra sutil para el efecto de profundidad
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none, // Oculta el borde por defecto si usas el color de fondo en el container
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}