import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/listeners/provider_nav.dart';

class NavBarW extends StatelessWidget {
  const NavBarW({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.orange.shade900,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                icon: Icons.home_outlined,
                title: 'Home',
                selectedIndex: navProvider.selectedIndex,
                onTap: navProvider.changeScreen,
              ),
              _NavItem(
                index: 1,
                icon: Icons.route_outlined,
                title: 'Rutas',
                selectedIndex: navProvider.selectedIndex,
                onTap: navProvider.changeScreen,
              ),
              _NavItem(
                index: 2,
                icon: Icons.search,
                title: 'Buscar',
                selectedIndex: navProvider.selectedIndex,
                onTap: navProvider.changeScreen,
              ),
              _NavItem(
                index: 3,
                icon: Icons.person_outline,
                title: 'Perfil',
                selectedIndex: navProvider.selectedIndex,
                onTap: navProvider.changeScreen,
              ),
              _NavItem(
                index: 4,
                icon: Icons.workspace_premium_outlined,
                title: 'Premium',
                selectedIndex: navProvider.selectedIndex,
                onTap: navProvider.changeScreen,
              ),
              _NavItem(
                index: 5,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Recargas',
                selectedIndex: navProvider.selectedIndex,
                onTap: navProvider.changeScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final int selectedIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.title,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.white.withOpacity(.6),
                size: isSelected ? 27 : 24,
              ),
              const SizedBox(height: 3),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(.6),
                    fontSize: 10,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
