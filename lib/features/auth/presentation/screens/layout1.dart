import 'package:flutter/material.dart';

void main() {
  runApp(const VerificationApp());
}

class VerificationApp extends StatelessWidget {
  const VerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VerificationScreen(),
    );
  }
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  // El color principal de la aplicación (rojo)
  final Color primaryColor = const Color(0xFFD32F2F);
  // El color de fondo claro (beige/crema)
  final Color backgroundColor = const Color(0xFFF7F5F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Establece el color de fondo general de la pantalla
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Alinea el contenido al inicio de la columna
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Título principal: "Verifica tu correo electrónico"
              Text(
                'Verifica tu correo electronico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor, // Usa el color rojo
                ),
              ),
              const SizedBox(height: 30),

              // Contenedor principal del formulario (simulado con Card)
              Card(
                // Un poco de elevación para destacarlo
                elevation: 4,
                // Bordes redondeados
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ocupa el espacio mínimo
                    children: <Widget>[
                      // Ícono del sobre (Email)
                      Icon(
                        Icons.mail_outline,
                        size: 80,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 20),

                      // Subtítulo: "Ingresa tu codigo de verificacion"
                      Text(
                        'Ingresa tu codigo de verificacion',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Campos de entrada de código OTP (simulados)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) => const OtpBox()),
                      ),
                      const SizedBox(height: 30),

                      // Botón principal: "Verificar codigo de acceso"
                      SizedBox(
                        width: double.infinity, // Ocupa todo el ancho
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción al verificar (puedes añadir tu lógica aquí)
                            debugPrint('Verificando código...');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // Fondo rojo
                            foregroundColor: Colors.white, // Texto blanco
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Verificar codigo de acceso'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sección "¿No has recibido el código?"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '¿No haz recibido el codigo? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  // Botón de reenvío (simulado con TextButton)
                  TextButton(
                    onPressed: () {
                      debugPrint('Reenviando código...');
                    },
                    child: Text(
                      'Reenviar de nuevo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.teal[400], // Usa un color verde azulado para el enlace
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para simular cada caja de entrada del OTP
class OtpBox extends StatelessWidget {
  const OtpBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Color de fondo de las cajas
        borderRadius: BorderRadius.circular(8),
        // Puedes añadir un borde para que se parezca más a un TextField vacío
        // border: Border.all(color: Colors.grey[400]!),
      ),
      // Podrías reemplazar este Container con un `TextField` configurado para un solo dígito
      child: const Center(
        // Text('1'), // Simular un dígito ingresado
      ),
    );
  }
}