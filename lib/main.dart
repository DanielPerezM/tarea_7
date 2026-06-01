import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/Screens/onBoarding.dart';
import 'package:tarea_7/firebase_options.dart';
import 'package:tarea_7/listeners/provider_nav.dart';
import 'package:tarea_7/listeners/provider_searchRutas.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tarea_7/utils/notification.dart';
import 'listeners/provider_theme.dart';
import 'package:tarea_7/stripe/stripe_service.dart';
import 'package:tarea_7/secret/stripe_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  //await notificationF.initNotifications();

  await Supabase.initialize(
    url: 'https://gdsnuhnhbqwhpsaaeovq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdkc251aG5oYnF3aHBzYWFlb3ZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAwMTUwMTksImV4cCI6MjA5NTU5MTAxOX0.OW5j313L0OUqaoPWqIAnektdqY-rUGWAUk9AdWwELDI',
  );

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
      //home: const Authenticate(),
      home: const OnBoardingS(),
      //home: const Prueba(),
    );
  }
}
