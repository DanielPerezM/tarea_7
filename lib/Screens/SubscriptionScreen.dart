import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/stripe/stripe_service.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SubscriptionS extends StatefulWidget {
  const SubscriptionS({super.key});

  @override
  State<SubscriptionS> createState() => _SubscriptionSState();
}

class _SubscriptionSState extends State<SubscriptionS> {
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
        title: Text("Suscripciones"),
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
                  onTap: () {
                    payment(
                      amountMembership: '49',
                      membershipName: 'Plan Básico',
                    );
                  },
                ),
                MembershipItemW(
                  title: 'Plan Plus',
                  price: '\$99 MXN',
                  description: 'Sin anuncios y alertas de movilidad.',
                  icon: Icons.star_outline,
                  onTap: () {
                    payment(
                      amountMembership: '99',
                      membershipName: 'Plan Plus',
                    );
                  },
                ),
                MembershipItemW(
                  title: 'Plan Premium',
                  price: '\$149 MXN',
                  description: 'Beneficios completos y contenido exclusivo.',
                  icon: Icons.workspace_premium_outlined,
                  onTap: () {
                    payment(
                      amountMembership: '149',
                      membershipName: 'Plan Premium',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> payment({
    required String amountMembership,
    required String membershipName,
  }) async {
    final stripeService = Provider.of<StripePaymentService>(
      context,
      listen: false,
    );

    try {
      await stripeService.initPaymentSheet(
        amount: amountMembership,
        currency: 'mxn',
        merchantName: 'RutaTiempo',
      );

      await stripeService.presentPaymentSheet();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pago exitoso: $membershipName')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al realizar el pago. Por favor, intente de nuevo',
          ),
        ),
      );
    }
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
