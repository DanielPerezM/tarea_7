import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/Screens/CentrosRecargaS.dart';
import 'package:tarea_7/Screens/HomeScreen.dart';
import 'package:tarea_7/Screens/ProfileInfScreen.dart';
import 'package:tarea_7/Screens/RutasInfScreen.dart';
import 'package:tarea_7/Screens/SearchScreen.dart';
import 'package:tarea_7/Screens/SubscriptionScreen.dart';
import 'package:tarea_7/listeners/provider_nav.dart';
import 'package:tarea_7/stripe/pay_through_stripe_screen.dart';
import 'package:tarea_7/widgets/NavBar.dart';

class MainNavigationS extends StatelessWidget {
  const MainNavigationS({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    final screens = [
      const HomeS(),
      const RutasInfS(),
      const SearchS(),
      const ProfileInfS(),
      const PayScreen(),
      const CentrosRecargasS(),
    ];

    return Scaffold(
      body: screens[navProvider.selectedIndex],
      bottomNavigationBar: const NavBarW(),
    );
  }
}
