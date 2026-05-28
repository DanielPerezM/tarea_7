/*import 'package:clon_wsp/Screens/loginS.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// ==============================
/// CREAR CUENTA
/// ==============================
Future<User?> createAccount(
  String userName,
  String email,
  String password,
  String phone,
  bool isProfessor,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user!.updateDisplayName(userName);

    await firestore.collection('users').doc(userCredential.user!.uid).set({
      "uid": userCredential.user!.uid,

      // Compatibilidad tutorial viejo
      "name": userName,

      // Nuevo nombre
      "userName": userName,

      "email": email,

      "phone": phone,

      "isProfessor": isProfessor,

      "avatarUrl": "",

      "status": "Offline",
    });

    debugPrint("Usuario creado correctamente");

    return userCredential.user;
  } catch (e) {
    debugPrint("Error creando cuenta: $e");

    return null;
  }
}

/// ==============================
/// LOGIN
/// ==============================
Future<User?> logIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    /// Iniciar sesión
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    debugPrint("Login correcto");

    try {
      /// Obtener datos del usuario desde Firestore
      DocumentSnapshot userData = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      /// Verificar si el documento existe
      if (userData.exists) {
        String name = userData['name'];

        /// Actualizar displayName
        await userCredential.user!.updateDisplayName(name);
      }
    } catch (e) {
      debugPrint("Error obteniendo datos usuario: $e");
    }

    return userCredential.user;
  } catch (e) {
    debugPrint("Error login: $e");
    return null;
  }
}

/// ==============================
/// LOGOUT
/// ==============================
Future<void> logOut(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    await googleSignIn.signOut();
    await auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginS()),
      (route) => false,
    );

    debugPrint("Sesión cerrada");
  } catch (e) {
    debugPrint("Error al cerrar sesión: $e");
  }
}

//si se ingresa con el numero de celular, se busca el correo ligado a es numeor y con ello da acceso
Future<User?> logInWithEmailOrPhone(
  String emailOrPhone,
  String password,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    String input = emailOrPhone.trim();

    bool isEmail = input.contains("@");

    String emailToLogin = input;

    if (!isEmail) {
      QuerySnapshot result = await firestore
          .collection('users')
          .where("phone", isEqualTo: input)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        debugPrint("No existe usuario con ese número");
        return null;
      }

      final data = result.docs.first.data() as Map<String, dynamic>;
      emailToLogin = data['email'];
    }

    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: emailToLogin,
      password: password,
    );

    return userCredential.user;
  } catch (e) {
    debugPrint("Error login email/teléfono: $e");
    return null;
  }
}

Future<User?> registerWithEmailPassword(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  } catch (e) {
    debugPrint("Error registro auth: $e");

    return null;
  }
}

Future<User?> signInWithGoogle() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      debugPrint("Login con Google cancelado");
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);

    return userCredential.user;
  } catch (e) {
    debugPrint("Error Google Sign-In: $e");
    return null;
  }
}
*/
