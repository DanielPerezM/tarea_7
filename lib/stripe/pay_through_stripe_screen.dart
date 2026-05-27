import 'package:flutter/material.dart';
import 'package:tarea_7/stripe/stripe_service.dart';
import 'package:provider/provider.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stripeService = Provider.of<StripePaymentService>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await stripeService.initPaymentSheet(
                amount: '10',
                currency: 'usd',
                merchantName: 'WTF Code',
              );
              await stripeService.presentPaymentSheet();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment successful")),
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Error: $e")));
            }
          },
          child: const Text('Pay \$10'),
        ),
      ),
    );
  }
}
