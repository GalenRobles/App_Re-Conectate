import 'package:flutter/material.dart';
import 'package:reconectate/app/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // ---------------------------
            // CARD: Qué es el Eneagrama
            // ---------------------------
            _menuCard(
              context,
              color: Colors.orange.shade300,
              icon: Icons.person,
              title: "Qué es el Eneagrama",
              onTap: () => _showIntroEneagrama(context),
            ),

            const SizedBox(height: 20),

            // ---------------------------
            // CARD: 9 tipos de personalidad
            // ---------------------------
            _menuCard(
              context,
              color: Colors.red.shade300,
              icon: Icons.auto_awesome,
              title: "Los 9 tipos de Personalidad",
              onTap: () => _showTiposList(context),
            ),

            const SizedBox(height: 40),
            const Text(
              "Comienza tu viaje de autodescubrimiento",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // TARJETA PRINCIPAL
  // ----------------------------------------------------------------------
  Widget _menuCard(
      BuildContext context, {
        required Color color,
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  )),
            )
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // MODAL: QUÉ ES EL ENEAGRAMA
  // ----------------------------------------------------------------------
  void _showIntroEneagrama(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Qué es el Eneagrama",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed),
              ),
              SizedBox(height: 10),
              Text(
                "Es un sistema que describe 9 tipos de personalidad diferentes, "
                    "llamados eneatipos, cada uno con sus fortalezas, desafíos y motivaciones.\n\n"
                    "Una herramienta poderosa de autoconocimiento que te ayuda a comprender "
                    "tus motivaciones profundas, miedos y patrones de comportamiento.",
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // LISTA DE LOS 9 TIPOS
  // ----------------------------------------------------------------------
  void _showTiposList(BuildContext context) {
    final tipos = [
      {"titulo": "TIPO 1 - Reformador", "color": Colors.red.shade400},
      {"titulo": "TIPO 2 - Colaborador", "color": Colors.pink.shade300},
      {"titulo": "TIPO 3 - Ejecutor", "color": Colors.amber.shade500},
      {"titulo": "TIPO 4 - Creador", "color": Colors.purple.shade300},
      {"titulo": "TIPO 5 - Observador", "color": Colors.blue.shade400},
      {"titulo": "TIPO 6 - Cuestionador", "color": Colors.cyan.shade400},
      {"titulo": "TIPO 7 - Animador", "color": Colors.green.shade400},
      {"titulo": "TIPO 8 - Luchador", "color": Colors.deepOrange.shade400},
      {"titulo": "TIPO 9 - Armonizador", "color": Colors.teal.shade400},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Los 9 tipos de personalidad",
                style: TextStyle(
                    fontSize: 22,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // LISTA DE TIPOS
              ...tipos.map((t) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: t["color"] as Color,
                    radius: 20,
                    child: const Icon(Icons.auto_awesome, color: Colors.white),
                  ),
                  title: Text(t["titulo"] as String),
                  onTap: () {
                    Navigator.pop(context);
                    _showTipoDetalle(
                      context,
                      titulo: t["titulo"] as String,
                      color: t["color"] as Color,
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // MODAL INDIVIDUAL POR TIPO
  // ----------------------------------------------------------------------
  void _showTipoDetalle(
      BuildContext context, {
        required String titulo,
        required Color color,
      }) {
    final descripciones = {
      "TIPO 1": "Perfeccionista, ético y orientado a mejorar el mundo.",
      "TIPO 2": "Amable, servicial, enfocado en ayudar y conectar.",
      "TIPO 3": "Exitoso, eficiente, ambicioso y orientado a logros.",
      "TIPO 4": "Creativo, emocional, profundo y auténtico.",
      "TIPO 5": "Analítico, curioso, reservado y mental.",
      "TIPO 6": "Leal, comprometido, cauteloso y protector.",
      "TIPO 7": "Optimista, entusiasta, divertido y espontáneo.",
      "TIPO 8": "Fuerte, directo, protector y líder natural.",
      "TIPO 9": "Pacífico, calmado, conciliador y armonioso.",
    };

    final key = titulo.split(" ")[1]; // extrae "1", "2", "3", etc.

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: color,
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 18),
              Text(
                titulo,
                style: const TextStyle(
                    fontSize: 22,
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                descripciones["TIPO $key"] ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}