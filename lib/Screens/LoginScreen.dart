import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tarea_7/Screens/SignUpS.dart';
import 'package:tarea_7/Screens/newProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tarea_7/methods.dart';
import 'package:tarea_7/utils/NavigationNavBar.dart';

class LoginS extends StatefulWidget {
  const LoginS({super.key});

  @override
  State<LoginS> createState() => _LoginSState();
}

class _LoginSState extends State<LoginS> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String formatMexicanPhone(String phone) {
    final cleanPhone = phone.trim().replaceAll(' ', '');

    if (cleanPhone.startsWith('+52')) {
      return cleanPhone;
    }

    return '+52$cleanPhone';
  }

  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginEmail() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      showMessage('Completa todos los campos');
      return;
    }

    setState(() => isLoading = true);

    final user = await AuthMethods().loginWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (user == null) {
      showMessage('Correo o contraseña incorrectos');
    }
  }

  Future<void> loginGoogle() async {
    setState(() => isLoading = true);

    final user = await AuthMethods().signInWithGoogle();

    if (!mounted) return;

    setState(() => isLoading = false);

    if (user == null) {
      showMessage('No se pudo iniciar sesión con Google');
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!mounted) return;

    if (doc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationS()),
      );
    } else {
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
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
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

              return isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: isDesktop ? 520 : double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: isDesktop ? 50 : 60),

                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                        child: const Text(
                                          "I N I C I A  S E S I Ó N",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 27,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FadeInUp(
                                        duration: const Duration(
                                          milliseconds: 1300,
                                        ),
                                        child: const Text(
                                          "Estás de vuelta",
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
                                      children: [
                                        FadeInUp(
                                          duration: const Duration(
                                            milliseconds: 1400,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                    225,
                                                    222,
                                                    27,
                                                    0.302,
                                                  ),
                                                  blurRadius: 20,
                                                  offset: Offset(0, 10),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade200,
                                                      ),
                                                    ),
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                        _emailController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.email_outlined,
                                                      ),
                                                      hintText:
                                                          "Correo o número de celular",
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),

                                                  child: TextField(
                                                    controller:
                                                        _passwordController,
                                                    obscureText:
                                                        _obscurePassword,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.lock_outline,
                                                      ),
                                                      hintText: "Contraseña",
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      border: InputBorder.none,
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          _obscurePassword
                                                              ? Icons
                                                                    .visibility_off
                                                              : Icons
                                                                    .visibility,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _obscurePassword =
                                                                !_obscurePassword;
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

                                        const SizedBox(height: 30),

                                        /*     FadeInUp(
                                          duration: const Duration(
                                            milliseconds: 1500,
                                          ),
                                          child: const Text(
                                            "¿Olvidaste tu contraseña?",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
*/
                                        const SizedBox(height: 30),

                                        FadeInUp(
                                          duration: const Duration(
                                            milliseconds: 1600,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: MaterialButton(
                                                  onPressed: loginEmail,
                                                  color: Colors.orange[900],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    "Entrar",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 15),

                                              SizedBox(
                                                width: double.infinity,
                                                height: 50,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            const SignUpS(),
                                                      ),
                                                    );
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: Colors
                                                          .orange
                                                          .shade900,
                                                      width: 2,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Regístrate",
                                                    style: TextStyle(
                                                      color: Colors
                                                          .orange
                                                          .shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 35),

                                        FadeInUp(
                                          duration: const Duration(
                                            milliseconds: 1700,
                                          ),
                                          child: const Text(
                                            "o ingresa con",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 25),

                                        Wrap(
                                          spacing: 20,
                                          runSpacing: 15,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            /*  FadeInUp(
                                              duration: const Duration(
                                                milliseconds: 1800,
                                              ),
                                              child: _SocialButton(
                                                text: "Facebook",
                                                color: Colors.blue,
                                                icon: Icons.facebook,
                                                onPressed: () {
                                                  Consumer<ThemeProvider>(
                                                    builder:
                                                        (
                                                          context,
                                                          themeProvider,
                                                          child,
                                                        ) {
                                                          return IconButton(
                                                            onPressed: () {
                                                              themeProvider
                                                                  .toggleTheme();
                                                            },
                                                            icon: Icon(
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? Icons
                                                                        .dark_mode
                                                                  : Icons
                                                                        .light_mode,
                                                            ),
                                                          );
                                                        },
                                                  );
                                                },
                                              ),
                                            )*/
                                            FadeInUp(
                                              duration: const Duration(
                                                milliseconds: 1900,
                                              ),
                                              child: _SocialButton(
                                                text: "Google",
                                                color: Colors.black,
                                                customIcon: const Text(
                                                  "G",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                onPressed: loginGoogle,
                                              ),
                                            ),
                                          ],
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

class _SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.icon,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 50,
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customIcon ?? Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
