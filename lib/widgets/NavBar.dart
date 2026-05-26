import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/listeners/provider_nav.dart';

class NavBarW extends StatelessWidget {
  const NavBarW({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GNav(
              selectedIndex: navProvider.selectedIndex,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.orange.shade900,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.orange.shade100,
              color: Colors.black,
              onTabChange: (index) {
                navProvider.changeScreen(index);
              },
              tabs: const [
                GButton(icon: LineIcons.home, text: 'Home'),
                GButton(icon: LineIcons.route, text: 'Rutas'),
                GButton(icon: LineIcons.search, text: 'Buscar'),
                GButton(icon: LineIcons.user, text: 'Perfil'),
                GButton(icon: LineIcons.creditCard, text: 'Premium'),
                GButton(icon: LineIcons.wallet, text: 'Recargas'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
