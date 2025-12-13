import 'package:flutter/material.dart';
import 'package:pick_my_dish/Models/recipe_model.dart';
import 'package:pick_my_dish/Services/api_service.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<int> _favoriteIds = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _recipes.where((r) => _favoriteIds.contains(r.id)).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Check if recipe is favorite
  bool isFavorite(int recipeId) => _favoriteIds.contains(recipeId);
  
  // Get recipe by ID
  Recipe? getRecipeById(int id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  // Load all recipes from API
  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> recipeMaps = await ApiService.getRecipes();
      _recipes = recipeMaps.map((json) => Recipe.fromJson(json)).toList();
      
      // Load favorites from local storage/sync here if needed
      // _favoriteIds = await _loadFavoritesFromStorage();
      
    } catch (e) {
      _error = 'Failed to load recipes: $e';
      debugPrint('❌ RecipeProvider load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle favorite
  void toggleFavorite(int recipeId) {
    if (_favoriteIds.contains(recipeId)) {
      _favoriteIds.remove(recipeId);
    } else {
      _favoriteIds.add(recipeId);
    }
    
    // Update recipe's isFavorite status
    final index = _recipes.indexWhere((r) => r.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(isFavorite: !_recipes[index].isFavorite);
    }
    
    // Save to storage/API here if needed
    // _saveFavoritesToStorage();
    
    notifyListeners();
  }

  // Filter recipes (for search)
  List<Recipe> filterRecipes(String query) {
    if (query.isEmpty) return _recipes;
    
    return _recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase()) ||
             recipe.category.toLowerCase().contains(query.toLowerCase()) ||
             recipe.moods.any((mood) => mood.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Personalize recipes (from your home screen)
  List<Recipe> personalizeRecipes({
    List<String>? ingredients,
    String? mood,
    String? time,
  }) {
    return _recipes.where((recipe) {
      bool matches = true;
      
      if (ingredients != null && ingredients.isNotEmpty) {
        matches = ingredients.any((ing) => 
          recipe.ingredients.any((recipeIng) => 
            recipeIng.toLowerCase().contains(ing.toLowerCase())
          )
        );
      }
      
      if (mood != null && mood.isNotEmpty) {
        matches = matches && recipe.moods.contains(mood);
      }
      
      if (time != null && time.isNotEmpty) {
        // Simple time matching - you can improve this
        matches = matches && recipe.cookingTime.contains(time);
      }
      
      return matches;
    }).toList();
  }

  // Clear data (for logout)
  void clear() {
    _recipes.clear();
    _favoriteIds.clear();
    _error = null;
    notifyListeners();
  }
}