import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/listeners/provider_nav.dart';
import 'package:tarea_7/listeners/provider_searchRutas.dart';
import 'package:tarea_7/utils/NavigationNavBar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'listeners/provider_theme.dart';
import 'package:tarea_7/stripe/stripe_service.dart';
import 'package:tarea_7/secret/stripe_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => RutasProvider()),

        Provider(create: (_) => StripePaymentService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MainNavigationS(),
    );
  }
}
