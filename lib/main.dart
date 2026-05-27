import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/listeners/provider_nav.dart';
import 'package:tarea_7/listeners/provider_searchRutas.dart';
import 'package:tarea_7/utils/NavigationNavBar.dart';

import 'listeners/provider_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => RutasProvider()),
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
