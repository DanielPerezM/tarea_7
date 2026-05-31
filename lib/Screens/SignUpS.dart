import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tarea_7/Screens/newProfile.dart';
import 'package:tarea_7/Screens/verifyNumS.dart';
import 'package:tarea_7/methods.dart';

class SignUpS extends StatefulWidget {
  const SignUpS({super.key});

  @override
  State<SignUpS> createState() => _SignUpSState();
}

class _SignUpSState extends State<SignUpS> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool registerByPhone = false;

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
  }

  Future<void> registerWithEmail() async {
    if (_email.text.trim().isEmpty ||
        _password.text.trim().isEmpty ||
        _confirmPassword.text.trim().isEmpty) {
      showMessage('Completa correo y contraseña');
      return;
    }

    if (_password.text.trim() != _confirmPassword.text.trim()) {
      showMessage('Las contraseñas no coinciden');
      return;
    }

    setState(() => isLoading = true);

    final user = await AuthMethods().registerWithEmail(
      userName: '',
      email: _email.text.trim(),
      phone: '',
      password: _password.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (user == null) {
      showMessage('No se pudo crear la cuenta');
      return;
    }

    await user.sendEmailVerification();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => verifyNumS(
          userName: '',
          email: _email.text.trim(),
          phone: '',
          isRegister: true,
          isEmailVerification: true,
        ),
      ),
    );
  }

  Future<void> registerWithPhone() async {
    if (_phone.text.trim().isEmpty) {
      showMessage('Ingresa número de celular');
      return;
    }

    final phone = _phone.text.trim();
    final formattedPhone = phone.startsWith('+52') ? phone : '+52$phone';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => verifyNumS(
          userName: '',
          email: '',
          phone: formattedPhone,
          isRegister: true,
          isEmailVerification: false,
        ),
      ),
    );
  }

  Future<void> registerWithGoogle() async {
    setState(() => isLoading = true);

    final user = await AuthMethods().signInWithGoogle();

    if (!mounted) return;

    setState(() => isLoading = false);

    if (user == null) {
      showMessage('No se pudo registrar con Google');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => newProfileS(
          userName: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          avatarUrl: user.photoURL ?? '',
        ),
      ),
    );
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool isDesktop = constraints.maxWidth >= 700;

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: SizedBox(
                      width: isDesktop ? 520 : double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: isDesktop ? 50 : 60),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1000),
                                  child: const Text(
                                    "C R E A  T U  C U E N T A",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1300),
                                  child: const Text(
                                    "Comienza a ahorrar tiempo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SwitchListTile(
                            value: registerByPhone,
                            activeColor: Colors.orange.shade900,
                            title: const Text(
                              'Registrarme por celular',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onChanged: (value) {
                              setState(() {
                                registerByPhone = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 40 : 30,
                                vertical: 35,
                              ),
                              child: Column(
                                children: <Widget>[
                                  FadeInUp(
                                    duration: const Duration(
                                      milliseconds: 1400,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                              225,
                                              95,
                                              27,
                                              .3,
                                            ),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          // CORREO
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _email,
                                              enabled: !registerByPhone,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.email_outlined,
                                                ),
                                                hintText: "Correo electrónico",
                                                filled: true,
                                                fillColor: registerByPhone
                                                    ? Colors.grey.shade300
                                                    : Colors.white,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),

                                          // CELULAR
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _phone,
                                              enabled: registerByPhone,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.phone_outlined,
                                                ),
                                                hintText: "Número de celular",
                                                filled: true,
                                                fillColor: registerByPhone
                                                    ? Colors.white
                                                    : Colors.grey.shade300,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),

                                          // CONTRASEÑA
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _password,
                                              obscureText: obscurePassword,
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.lock_outline,
                                                ),
                                                hintText: "Crear contraseña",
                                                hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    obscurePassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      obscurePassword =
                                                          !obscurePassword;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),

                                          // CONFIRMAR CONTRASEÑA
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: TextField(
                                              controller: _confirmPassword,
                                              obscureText:
                                                  obscureConfirmPassword,
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.lock_reset_outlined,
                                                ),
                                                hintText:
                                                    "Confirmar contraseña",
                                                hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    obscureConfirmPassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      obscureConfirmPassword =
                                                          !obscureConfirmPassword;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 35),

                                  FadeInUp(
                                    duration: const Duration(
                                      milliseconds: 1600,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (registerByPhone) {
                                            registerWithPhone();
                                          } else {
                                            registerWithEmail();
                                          }
                                        },
                                        color: Colors.orange[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: const Text(
                                          "Registrarme",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 35),

                                  FadeInUp(
                                    duration: const Duration(
                                      milliseconds: 1700,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "¿Ya tienes una cuenta? Inicia sesión",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
