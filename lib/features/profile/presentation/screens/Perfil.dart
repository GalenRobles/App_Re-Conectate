import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/services/FirestoreService.dart';
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
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100)),
              ),
              child: Center(
                child: userProfile?['photoUrl'] != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage:
                  NetworkImage(userProfile!['photoUrl']),
                )
                    : const Icon(Icons.account_circle,
                    size: 100, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '${userProfile?['nombre'] ?? 'Usuario'} ${userProfile?['apellido'] ?? ''}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                context.go('/');
              },
              child: const Text('Cerrar sesión'),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
