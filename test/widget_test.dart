// Archivo: lib/features/home_courses/data/domain/presentation/screens/home.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/providers/auth_providers.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.appBackground,

      // --- 1. AppBar Personalizado ---
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 35,
        ),
        centerTitle: false,
        backgroundColor: AppColors.appBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: AppColors.primaryRed,
              size: 30,
            ),
            onPressed: () {
              context.push('/perfil');
            },
          ),
          const SizedBox(width: 16),
        ],
      ),

      // --- 2. Cuerpo de la Pantalla ---
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Video Destacado ---
              Text(
                'Video Destacado',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 60),
                ),
              ),
              const SizedBox(height: 24),

              // --- Banner Creadora (¡Con Degradado!) ---
              _buildCreatorBanner(context),

              const SizedBox(height: 24),

              // --- Eneagrama: La Herramienta ---
              Text(
                'Eneagrama: La Herramienta',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // --- BLOQUE 1: DESPLEGABLE (Qué es el Eneagrama) ---
              _buildExpansionTile(
                context: context,
                iconBackgroundColor: AppColors.primaryYellow.withOpacity(0.3),
                icon: Icons.person_outline,
                title: 'Qué es el Eneagrama',
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'Es un sistema que describe 9 tipos de personalidad diferentes, llamados eneatipos, cada uno con sus propias fortalezas, desafíos y motivaciones. Es una herramienta poderosa para el autoconocimiento...',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- BLOQUE 2: DESPLEGABLE (Los 9 tipos) ---
              _buildExpansionTile(
                context: context,
                iconBackgroundColor: AppColors.primaryRed.withOpacity(0.3),
                icon: Icons.apps,
                title: 'Los 9 tipos de Personalidad',
                children: [
                  _buildPersonalityType(context, 'TIPO 1', 'REFORMADOR'),
                  _buildPersonalityType(context, 'TIPO 2', 'COLABORADOR'),
                  _buildPersonalityType(context, 'TIPO 3', 'EJECUTOR'),
                  _buildPersonalityType(context, 'TIPO 4', 'CREADOR'),
                  _buildPersonalityType(context, 'TIPO 5', 'OBSERVADOR'),
                  _buildPersonalityType(context, 'TIPO 6', 'CUESTIONADOR'),
                  _buildPersonalityType(context, 'TIPO 7', 'ANIMADOR'),
                  _buildPersonalityType(context, 'TIPO 8', 'LUCHADOR'),
                  _buildPersonalityType(context, 'TIPO 9', 'ARMONIZADOR'),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Auxiliar para el Banner (con degradado) ---
  Widget _buildCreatorBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryYellow.withOpacity(0.8),
            AppColors.primaryYellow.withOpacity(0.5),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conoce a la creadora',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Betty Ruiz',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              // CORRECCIÓN: Sobrescribimos el minimumSize del tema
              // para que el botón se ajuste a su contenido (padding).
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Ver Bio'),
          ),
        ],
      ),
    );
  }

  // --- Widget Auxiliar para los Bloques Desplegables ---
  Widget _buildExpansionTile({
    required BuildContext context,
    required Color iconBackgroundColor,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: iconBackgroundColor,
          child: Icon(icon, color: AppColors.textPrimary),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(),
        children: children,
      ),
    );
  }

  // --- Widget Auxiliar para los Tipos de Personalidad ---
  Widget _buildPersonalityType(BuildContext context, String type, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type, style: Theme.of(context).textTheme.bodyMedium),
          Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }
}