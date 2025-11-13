import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/theme/app_colors.dart';
// ¡CRÍTICO! Importa el provider que tiene el profileStreamProvider
import 'package:app/providers/auth_providers.dart';

// Definimos el color exacto para el degradado
final Color _yellowGold = const Color(0xFFF6C555);

// ----------------------------------------------------------------------
// WIDGETS AUXILIARES (Funciones de Soporte para la UI)
// (Tu código aquí es correcto, los he colapsado por brevedad)
// ----------------------------------------------------------------------

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

Widget _buildCreatorBanner(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.primaryRed,
          _yellowGold,
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
          backgroundImage: AssetImage('assets/images/foto_creadora.png'),
          backgroundColor: AppColors.white,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Conoce a la creadora', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              const Text('Betty Ruiz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.primaryRed,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: const Text('Ver Bio'),
        ),
      ],
    ),
  );
}

// ----------------------------------------------------------------------
// WIDGET PRINCIPAL: HomeView (Corregido con Carga Asíncrona)
// ----------------------------------------------------------------------
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // --- 1. CONECTAMOS EL PROVIDER DE PERFIL ---
    // Este provider (que creaste en auth_providers.dart)
    // obtiene el usuario de Auth Y LUEGO busca su perfil en Firestore.
    final profileAsyncValue = ref.watch(profileStreamProvider);

    final textTheme = Theme.of(context).textTheme;

    // --- 2. USAMOS .when() PARA MANEJAR LA CARGA ---
    // Esto evita que la app se congele en el Login.
    return profileAsyncValue.when(

      // ⏳ ESTADO DE CARGA:
      loading: () => const Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Center(child: CircularProgressIndicator()),
      ),

      // 🚨 ESTADO DE ERROR:
      error: (err, stack) => Scaffold(
        backgroundColor: AppColors.appBackground,
        body: Center(child: Text('Error al cargar perfil: $err')),
      ),

      // ✅ ESTADO DE ÉXITO (Datos Cargados):
      data: (profileData) {

        // Obtenemos el nombre del mapa de datos de Firestore
        final nombreUsuario = profileData?['nombre'] ?? 'Invitado';

        // --- 3. CONSTRUIMOS LA UI (Tu código de diseño) ---
        // Este Scaffold solo se construye DESPUÉS de que los datos llegaron.
        return Scaffold(
          backgroundColor: AppColors.appBackground,

          appBar: AppBar(
            // Mostramos el nombre del usuario real
            title: Text('¡Hola, $nombreUsuario!', style: textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary)),
            centerTitle: false,
            backgroundColor: AppColors.appBackground,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, color: AppColors.primaryRed, size: 30),
                onPressed: () {
                  context.push('/perfil');
                },
              ),
              const SizedBox(width: 16),
            ],
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Video Destacado', style: textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 16),

                  // ⚠️ NOTA: El video también debe cargarse asíncronamente
                  Container(height: 200, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12))),
                  const SizedBox(height: 24),

                  _buildCreatorBanner(context),

                  const SizedBox(height: 24),

                  Text('Eneagrama: La Herramienta', style: textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 16),

                  // Bloques Desplegables
                  _buildExpansionTile(
                    context: context,
                    iconBackgroundColor: AppColors.primaryYellow.withOpacity(0.3),
                    icon: Icons.person_outline,
                    title: 'Qué es el Eneagrama',
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text('Es un sistema que describe 9 tipos de personalidad diferentes...', style: TextStyle(fontSize: 14, height: 1.5)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

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

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.white,
            currentIndex: 0,
            selectedItemColor: AppColors.primaryRed,
            unselectedItemColor: AppColors.textSecondary,
            onTap: (index) {
              if (index == 0) context.go('/home');    // 🔹 Inicio
              if (index == 1) context.go('/cursos');  // 🔹 Mis Cursos
              if (index == 2) context.go('/perfil');  // 🔹 Perfil
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Mis cursos'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),

        );
      },
    );
  }
}