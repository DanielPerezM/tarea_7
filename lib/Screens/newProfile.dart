import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarea_7/utils/NavigationNavBar.dart';

class newProfileS extends StatefulWidget {
  final String userName;
  final String email;
  final String phone;
  final String avatarUrl;

  const newProfileS({
    super.key,
    required this.userName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
  });

  @override
  State<newProfileS> createState() => _newProfileSState();
}

class _newProfileSState extends State<newProfileS> {
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool get canEditEmail => widget.email.trim().isEmpty;
  bool get canEditPhone => widget.phone.trim().isEmpty;

  File? imageFile;
  String avatarUrl = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    avatarUrl = widget.avatarUrl;
    _userNameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    avatarUrl = widget.avatarUrl;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
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

  ImageProvider? getProfileImage() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }

    if (avatarUrl.isNotEmpty) {
      return CachedNetworkImageProvider(avatarUrl);
    }

    return null;
  }

  Future<void> saveProfile() async {
    if (_userNameController.text.trim().isEmpty) {
      showMessage('El nombre de usuario no puede estar vacío');
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() => isLoading = false);
        showMessage('No hay usuario autenticado');
        return;
      }

      final finalAvatarUrl = await uploadAvatarToSupabase(user.uid);

      await user.updateDisplayName(_userNameController.text.trim());

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'userName': _userNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'avatarUrl': finalAvatarUrl,
        'subscription': 'free',
        'favoriteRoutes': [],
      });

      if (!mounted) return;

      setState(() => isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationS()),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      showMessage('Error al guardar perfil: $e');
    }
  }

  ImageProvider? getAvatarImage() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }

    if (avatarUrl.isNotEmpty) {
      return NetworkImage(avatarUrl);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            'Crea tu perfil',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
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
                          _field(_userNameController, 'Nombre', Icons.person),
                          _field(
                            _emailController,
                            'Correo',
                            Icons.email,
                            keyboard: TextInputType.emailAddress,
                            enabled: canEditEmail,
                          ),
                          _field(
                            _phoneController,
                            'Celular',
                            Icons.phone,
                            keyboard: TextInputType.phone,
                            enabled: canEditPhone,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: MaterialButton(
                              color: Colors.orange.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onPressed: saveProfile,
                              child: const Text(
                                'Guardar perfil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        enabled: enabled,
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade300,
          prefixIcon: Icon(icon),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
