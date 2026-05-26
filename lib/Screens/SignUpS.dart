import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SignUpS extends StatelessWidget {
  const SignUpS({super.key});

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
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: const TextField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
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
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade200,
                                                ),
                                              ),
                                            ),
                                            child: const TextField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.lock_outline,
                                                ),
                                                hintText: "Crear contraseña",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),

                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: const TextField(
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.lock_reset_outlined,
                                                ),
                                                hintText:
                                                    "Confirmar contraseña",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
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
                                        onPressed: () {},
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
