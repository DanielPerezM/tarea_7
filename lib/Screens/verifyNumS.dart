import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarea_7/Screens/newProfile.dart';

class verifyNumS extends StatefulWidget {
  final String userName;
  final String email;
  final String phone;
  final bool isRegister;
  final bool isEmailVerification;

  const verifyNumS({
    super.key,
    required this.userName,
    required this.email,
    required this.phone,
    required this.isRegister,
    required this.isEmailVerification,
  });

  @override
  State<verifyNumS> createState() => _verifyNumSState();
}

class _verifyNumSState extends State<verifyNumS> {
  final TextEditingController _codeController = TextEditingController();

  String verificationId = '';
  bool isLoading = false;
  bool canResend = true;

  @override
  void initState() {
    super.initState();

    if (!widget.isEmailVerification) {
      sendCode();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
  }

  Future<void> sendCode() async {
    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (!mounted) return;

        goToProfile(email: '', phone: widget.phone);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;

        setState(() => isLoading = false);

        showMessage(e.message ?? 'No se pudo enviar el código de verificación');
      },
      codeSent: (String id, int? resendToken) {
        verificationId = id;

        if (!mounted) return;

        setState(() => isLoading = false);

        showMessage('Código enviado correctamente');
      },
      codeAutoRetrievalTimeout: (String id) {
        verificationId = id;
      },
    );
  }

  Future<void> verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      showMessage('Ingresa el código SMS');
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _codeController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      goToProfile(email: '', phone: widget.phone);
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      showMessage('Código incorrecto');
    }
  }

  Future<void> verifyEmail() async {
    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => isLoading = false);
      showMessage('No hay usuario autenticado');
      return;
    }

    await user.reload();

    final updatedUser = FirebaseAuth.instance.currentUser;

    if (updatedUser != null && updatedUser.emailVerified) {
      if (!mounted) return;

      goToProfile(email: widget.email, phone: '');
    } else {
      if (!mounted) return;

      setState(() => isLoading = false);

      showMessage('Aún no has verificado tu correo');
    }
  }

  String formatMexicanPhone(String phone) {
    final cleanPhone = phone.trim().replaceAll(' ', '');

    if (cleanPhone.startsWith('+52')) {
      return cleanPhone;
    }

    return '+52$cleanPhone';
  }

  void goToProfile({required String email, required String phone}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => newProfileS(
          userName: widget.userName,
          email: email,
          phone: phone,
          avatarUrl: '',
        ),
      ),
    );
  }

  Widget field() {
    return TextField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.sms),
        hintText: 'Código SMS',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmail = widget.isEmailVerification;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        try {
          await FirebaseAuth.instance.signOut();
        } catch (_) {}

        if (!mounted) return;

        Navigator.pop(context);
      },
      child: Scaffold(
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
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                              } catch (_) {}

                              if (!mounted) return;

                              Navigator.pop(context);
                            },
                          ),
                        ),

                        const SizedBox(height: 80),

                        Icon(
                          isEmail ? Icons.email_outlined : Icons.phone_android,
                          color: Colors.white,
                          size: 80,
                        ),

                        const SizedBox(height: 25),

                        Text(
                          isEmail ? 'Verifica tu correo' : 'Verifica tu número',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          isEmail
                              ? 'Te enviamos un enlace de verificación a:\n${widget.email}'
                              : 'Te enviamos un código SMS a:\n${widget.phone}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 45),

                        if (!isEmail) field(),

                        if (!isEmail) const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: MaterialButton(
                            color: Colors.orange.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onPressed: isEmail ? verifyEmail : verifyCode,
                            child: Text(
                              isEmail ? 'Ya verifiqué mi correo' : 'Verificar',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: !canResend
                              ? null
                              : () async {
                                  setState(() => canResend = false);

                                  final user =
                                      FirebaseAuth.instance.currentUser;

                                  if (user != null) {
                                    await user.sendEmailVerification();
                                    showMessage(
                                      'Correo de verificación reenviado',
                                    );
                                  }

                                  await Future.delayed(
                                    const Duration(seconds: 30),
                                  );

                                  if (!mounted) return;
                                  setState(() => canResend = true);
                                },
                          child: Text(
                            isEmail
                                ? 'Reenviar correo de verificación'
                                : 'Reenviar código',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
