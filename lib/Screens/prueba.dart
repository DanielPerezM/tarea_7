import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Prueba extends StatefulWidget {
  Prueba({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PruebaState createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  @override
  Widget build(BuildContext context) {
    void showMessage(String text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text, textAlign: TextAlign.center),
          duration: const Duration(milliseconds: 700),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                MembershipItemW(
                  title: 'Plan Básico',
                  price: '\$49 MXN',
                  description: 'Acceso a rutas y avisos básicos.',
                  icon: Icons.directions_bus,
                  onTap: () => showMessage('Seleccionaste Plan Básico'),
                ),
                MembershipItemW(
                  title: 'Plan Plus',
                  price: '\$99 MXN',
                  description: 'Sin anuncios y alertas de movilidad.',
                  icon: Icons.star_outline,
                  onTap: () => showMessage('Seleccionaste Plan Plus'),
                ),
                MembershipItemW(
                  title: 'Plan Premium',
                  price: '\$149 MXN',
                  description: 'Beneficios completos y contenido exclusivo.',
                  icon: Icons.workspace_premium_outlined,
                  onTap: () => showMessage('Seleccionaste Plan Premium'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MembershipItemW extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const MembershipItemW({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      begin: 1.0,
      end: 0.9,
      longTapRepeatDuration: const Duration(milliseconds: 100),
      beginDuration: const Duration(milliseconds: 20),
      endDuration: const Duration(milliseconds: 120),
      beginCurve: Curves.decelerate,
      endCurve: Curves.fastOutSlowIn,
      child: Container(
        width: 320,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Icon(icon, size: 46, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
