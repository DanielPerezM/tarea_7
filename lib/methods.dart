import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerWithEmail({
    required String userName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await user.updateDisplayName(userName);

        await _firestore.collection('users').doc(user.uid).set({
          'userName': userName,
          'email': email,
          'phone': phone,
          'avatarUrl': '',
          'subscription': 'free',
        });
      }

      return user;
    } catch (e) {
      debugPrint('Error registro: $e');
      return null;
    }
  }

  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (e) {
      debugPrint('Error login: $e');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("Login con Google cancelado");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      debugPrint("Error Google Sign-In: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
    }
  }

  Future<User?> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    try {
      String formattedPhone = phone.trim();

      if (!formattedPhone.startsWith('+52')) {
        formattedPhone = '+52$formattedPhone';
      }

      final result = await _firestore
          .collection('users')
          .where('phone', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        return null;
      }

      final userData = result.docs.first.data();

      final email = userData['email'];

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (e) {
      debugPrint('Error login teléfono: $e');
      return null;
    }
  }

  Future<User?> loginWithEmailOrPhone({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      String input = emailOrPhone.trim();
      String emailToLogin = input;

      if (!input.contains('@')) {
        final result = await _firestore
            .collection('users')
            .where('phone', isEqualTo: input)
            .limit(1)
            .get();

        if (result.docs.isEmpty) return null;

        emailToLogin = result.docs.first.data()['email'];
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: emailToLogin,
        password: password,
      );

      return credential.user;
    } catch (e) {
      debugPrint('Error login email/teléfono: $e');
      return null;
    }
  }

  Future<void> sendPhoneCode({
    required String phone,
    required Function(String verificationId) codeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Error al verificar número');
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<User?> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint('Error verificando código: $e');
      return null;
    }
  }
}
