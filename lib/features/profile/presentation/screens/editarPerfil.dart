import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/services/FirestoreService.dart';
import 'package:app/services/FirestoreService.dart';
import 'package:app/features/profile/presentation/screens/validators.dart';
import 'package:app/features/profile/presentation/screens/custom_snackbar.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final _auth = FirebaseAuth.instance;
  final _firestoreService = FirestoreService();

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

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
      if (data != null) {
        nameController.text = data['nombre'] ?? '';
        lastNameController.text = data['apellido'] ?? '';
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      CustomSnackBar.show(context,
          message: 'Por favor corrige los errores antes de continuar',
          isError: true);
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    await _firestoreService.updateUserProfile(
      user.uid,
      {
        'nombre': nameController.text.trim(),
        'apellido': lastNameController.text.trim(),
      },
    );

    CustomSnackBar.show(context,
        message: 'Perfil actualizado correctamente ✅', isError: false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EDE0),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4DDA2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: validateName,
                        decoration:
                        const InputDecoration(labelText: 'Nombre'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: lastNameController,
                        validator: validateLastName,
                        decoration:
                        const InputDecoration(labelText: 'Apellido'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                        ),
                        onPressed: _saveChanges,
                        child: const Text(
                          'Guardar y Salir',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


