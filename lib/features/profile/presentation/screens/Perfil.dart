import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:reconectate/app/theme/app_colors.dart';
import 'package:reconectate/services/FirestoreService.dart';
import 'editarPerfil.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final _auth = FirebaseAuth.instance;
  final _firestoreService = FirestoreService();

  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final data = await _firestoreService.getUserProfile(user.uid);
      setState(() {
        userProfile = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // 🔹 Header
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Center(
                child: userProfile?['photoUrl'] != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  NetworkImage(userProfile!['photoUrl']),
                )
                    : const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Nombre y apellido
            Text(
              '${userProfile?['nombre'] ?? 'Usuario'} ${userProfile?['apellido'] ?? ''}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              userProfile?['email'] ?? 'Sin correo',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditarPerfil(),
                  ),
                );
                _loadUserProfile(); //
              },
              child: const Text(
                'Editar Perfil',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Cuadro "Mejora tu plan"
            Container(
              width: 300,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Mejora tu plan\n\nObtén acceso a información más detallada especialmente para ti, conoce mejor tu eneagrama y empieza a entenderte mejor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.language, color: AppColors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
              ),
              onPressed: () {},
              label: const Text(
                'Explorar el curso completo',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                onPressed: () async {
                  await _auth.signOut();

                  if (!mounted) return;

                  // 🔹 Redirige limpiamente al Login
                  context.go('/login');
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Barra inferior con navegación funcional
            Container(
              height: 60,
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavIcon(
                    icon: Icons.home,
                    label: 'Inicio',
                    onTap: () => context.go('/home'),
                  ),
                  _NavIcon(
                    icon: Icons.menu_book,
                    label: 'Mis cursos',
                    onTap: () => context.go('/cursos'),
                  ),
                  _NavIcon(
                    icon: Icons.person,
                    label: 'Perfil',
                    active: true,
                    onTap: () => context.go('/perfil'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Widget de ícono de navegación
class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 cuando se toca, ejecuta la navegación
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? AppColors.primaryRed : AppColors.textSecondary,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? AppColors.primaryRed : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


