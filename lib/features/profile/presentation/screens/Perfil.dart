import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart'; // ✅ necesario para redirección limpia
import 'package:app/app/theme/app_colors.dart';
import 'package:app/services/FirestoreService.dart';
import 'editarPerfil.dart';
import 'package:app/features/profile/presentation/screens/custom_bottom_nav.dart';

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
                borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(100)),
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
            const SizedBox(height: 20),
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
                _loadUserProfile();
              },
              child: const Text(
                'Editar Perfil',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
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

                  // 🔹 Redirige limpiamente al Login (sin poder volver atrás)
                  context.go('/');
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}

