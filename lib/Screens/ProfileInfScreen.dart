import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarea_7/methods.dart';

class ProfileInfS extends StatefulWidget {
  const ProfileInfS({super.key});

  @override
  State<ProfileInfS> createState() => _ProfileInfSState();
}

class _ProfileInfSState extends State<ProfileInfS> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  File? imageFile;
  String avatarUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  void dispose() {
    _userName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
  }

  Future<void> getProfileData() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;
      setState(() => isLoading = false);
      return;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!mounted) return; // 👈 importante antes de usar controllers

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      _userName.text = data['userName'] ?? '';
      _email.text = data['email'] ?? '';
      _phone.text = data['phone'] ?? '';
      avatarUrl = data['avatarUrl'] ?? '';
    }

    if (!mounted) return;

    setState(() => isLoading = false);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadAvatarToSupabase(String uid) async {
    if (imageFile == null) {
      return avatarUrl;
    }

    final fileName = 'Perfiles/$uid.jpg';

    await Supabase.instance.client.storage
        .from('Fotos')
        .upload(
          fileName,
          imageFile!,
          fileOptions: const FileOptions(upsert: true),
        );

    return Supabase.instance.client.storage
        .from('Fotos')
        .getPublicUrl(fileName);
  }

  Future<void> updateProfile() async {
    final userName = _userName.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();

    if (userName.isEmpty) {
      showMessage('El nombre de usuario no puede estar vacío');
      return;
    }

    if (email.isEmpty && phone.isEmpty) {
      showMessage('Ingresa un correo o número celular');
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = _auth.currentUser;

      if (user == null) {
        setState(() => isLoading = false);
        showMessage('No hay usuario autenticado');
        return;
      }

      final finalAvatarUrl = await uploadAvatarToSupabase(user.uid);

      await user.updateDisplayName(userName);

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'userName': userName,
        'email': email,
        'phone': phone,
        'avatarUrl': finalAvatarUrl,
        'subscription': 'free',
        'favoriteRoutes': [],
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        avatarUrl = finalAvatarUrl;
        isLoading = false;
      });

      showMessage('Perfil actualizado correctamente');
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      showMessage('Error al actualizar perfil: $e');
      print(e);
    }
  }

  Future<void> logout() async {
    await AuthMethods().logout();
  }

  ImageProvider? getProfileImage() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }

    if (avatarUrl.isNotEmpty) {
      return CachedNetworkImageProvider(avatarUrl);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Text(
                    'Mi Perfil',
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 35),

                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.white,
                      backgroundImage: getProfileImage(),
                      child: getProfileImage() == null
                          ? Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.orange.shade900,
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Toca para cambiar foto',
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  field(
                    size,
                    'Nombre de usuario',
                    Icons.person,
                    _userName,
                    TextInputType.text,
                  ),

                  const SizedBox(height: 18),

                  field(
                    size,
                    'Correo electrónico',
                    Icons.email,
                    _email,
                    TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 18),

                  field(
                    size,
                    'Celular',
                    Icons.phone,
                    _phone,
                    TextInputType.phone,
                  ),

                  const SizedBox(height: 35),

                  button(
                    size,
                    'Guardar cambios',
                    updateProfile,
                    Colors.orange.shade900,
                  ),

                  const SizedBox(height: 18),

                  button(size, 'Cerrar sesión', logout, Colors.redAccent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget button(Size size, String text, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget field(
    Size size,
    String hintText,
    IconData icon,
    TextEditingController controller,
    TextInputType keyboard,
  ) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.orange.shade900),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
