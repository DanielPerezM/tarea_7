import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int selectedIndex = 0;

  void changeScreen(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
