import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final List<int> _favoriteIds = [];

  List<int> get favoriteIds => _favoriteIds;
  
  bool isFavorite(int recipeId) => _favoriteIds.contains(recipeId);
  
  void toggleFavorite(int recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    notifyListeners();
  }
}