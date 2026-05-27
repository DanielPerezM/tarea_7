import 'package:flutter/material.dart';

enum FavoriteShape { grid, list }

class RutasProvider extends ChangeNotifier {
  String query = '';
  FavoriteShape viewMode = FavoriteShape.grid;

  void updateQuery(String value) {
    query = value.toLowerCase();
    notifyListeners();
  }

  void changeViewMode(FavoriteShape value) {
    viewMode = value;
    notifyListeners();
  }
}
