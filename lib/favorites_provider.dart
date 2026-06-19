import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  bool isFavorite(Map<String, dynamic> perfume) {
    return _favorites.any((item) => item['name'] == perfume['name']);
  }

  void toggleFavorite(Map<String, dynamic> perfume) {
    final index = _favorites.indexWhere(
          (item) => item['name'] == perfume['name'],
    );

    if (index == -1) {
      perfume['isFavorite'] = true;
      _favorites.add(perfume);
    } else {
      perfume['isFavorite'] = false;
      _favorites.removeAt(index);
    }

    notifyListeners();
  }

  void clearFavorites() {
    for (var item in _favorites) {
      item['isFavorite'] = false;
    }

    _favorites.clear();
    notifyListeners();
  }
}