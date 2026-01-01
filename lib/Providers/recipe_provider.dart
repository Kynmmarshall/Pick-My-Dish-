// Import Flutter material library
import 'package:flutter/material.dart';

// Import Recipe model
import 'package:pick_my_dish/Models/recipe_model.dart';

// Import UserProvider (used for permission logic if needed)
import 'package:pick_my_dish/Providers/user_provider.dart';

// Import API service for backend communication
import 'package:pick_my_dish/Services/api_service.dart';

/// RecipeProvider
/// Handles recipe state management, favorites, filtering,
/// personalization, and API synchronization
class RecipeProvider with ChangeNotifier {

  // List of all recipes fetched from the backend
  List<Recipe> _recipes = [];

  // List of recipes marked as favorites by the current user
  List<Recipe> _userFavorites = [];

  // Indicates whether a loading operation is in progress
  bool _isLoading = false;

  // Stores error messages if an operation fails
  String? _error;

  // -------------------- Getters --------------------

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _userFavorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Dummy mounted getter (kept for compatibility)
  bool get mounted => true;

  // -------------------- Favorite Logic --------------------

  /// Checks if a recipe is marked as favorite
  bool isFavorite(int recipeId) =>
      _userFavorites.any((recipe) => recipe.id == recipeId);

  /// Toggles favorite status for a recipe
  /// - Adds to favorites if not already favorite
  /// - Removes from favorites if already favorite
  Future<void> toggleFavorite(int userId, int recipeId) async {
    debugPrint('🔄 RecipeProvider.toggleFavorite called');

    // User must be logged in
    if (userId == 0) {
      debugPrint('❌ Cannot toggle favorite: user not logged in');
      return;
    }

    // Retrieve recipe from main list
    final recipe = getRecipeById(recipeId);
    if (recipe == null) {
      debugPrint('❌ Recipe not found');
      return;
    }

    // Determine current favorite state
    bool wasFavorite = isFavorite(recipeId);
    bool success;

    if (wasFavorite) {
      // Remove recipe from favorites
      success = await ApiService.removeFromFavorites(userId, recipeId);
      if (success) {
        _userFavorites.removeWhere((r) => r.id == recipeId);
      }
    } else {
      // Add recipe to favorites
      success = await ApiService.addToFavorites(userId, recipeId);
      if (success) {
        _userFavorites.add(recipe);
      }
    }

    // Update local lists if API call succeeded
    if (success) {
      final index = _recipes.indexWhere((r) => r.id == recipeId);
      if (index != -1) {
        _recipes[index] =
            _recipes[index].copyWith(isFavorite: !wasFavorite);
      }

      // Synchronize favorites across all recipes
      _syncFavoriteStatus();

      // Reload recipes to ensure consistency
      await loadRecipes();

      // Notify UI listeners asynchronously
      Future.microtask(() => notifyListeners());
    }
  }

  // -------------------- Utility Methods --------------------

  /// Returns a recipe by its ID
  Recipe? getRecipeById(int id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  // -------------------- Favorites Loading --------------------

  /// Loads favorite recipes for the given user
  Future<void> loadUserFavorites(int userId) async {
    if (userId == 0) {
      // Clear favorites if user is logged out
      _userFavorites = [];
      Future.microtask(() => notifyListeners());
      return;
    }

    _isLoading = true;

    try {
      final favoriteMaps = await ApiService.getUserFavorites(userId);
      _userFavorites =
          favoriteMaps.map((map) => Recipe.fromJson(map)).toList();
    } catch (e) {
      _error = 'Failed to load favorites';
      debugPrint('❌ Error loading favorites: $e');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  // -------------------- Session Handling --------------------

  /// Clears all recipe data on user logout
  void logout() {
    _recipes.clear();
    _userFavorites.clear();
    notifyListeners();
  }

  // -------------------- Recipe Loading --------------------

  /// Loads all recipes from the backend
  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final recipeMaps = await ApiService.getRecipes();
      _recipes =
          recipeMaps.map((json) => Recipe.fromJson(json)).toList();

      // Synchronize favorite flags
      _syncFavoriteStatus();
    } catch (e) {
      _error = 'Failed to load recipes';
      debugPrint('❌ Recipe load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Synchronizes the isFavorite flag of each recipe
  void _syncFavoriteStatus() {
    for (int i = 0; i < _recipes.length; i++) {
      final recipe = _recipes[i];
      final isFav =
          _userFavorites.any((fav) => fav.id == recipe.id);

      if (recipe.isFavorite != isFav) {
        _recipes[i] = recipe.copyWith(isFavorite: isFav);
      }
    }
  }

  // -------------------- Filtering & Personalization --------------------

  /// Filters recipes based on search query
  List<Recipe> filterRecipes(String query) {
    if (query.isEmpty) return _recipes;

    return _recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase()) ||
          recipe.category
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          recipe.moods.any(
              (mood) => mood.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  /// Returns personalized recipes based on ingredients, mood, and time
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
                recipeIng.toLowerCase().contains(ing.toLowerCase())));
      }

      if (mood != null && mood.isNotEmpty) {
        matches = matches && recipe.moods.contains(mood);
      }

      if (time != null && time.isNotEmpty) {
        matches = matches && recipe.cookingTime.contains(time);
      }

      return matches;
    }).toList();
  }

  // -------------------- Permissions --------------------

  /// Checks if the user can edit a recipe
  bool canEditRecipe(int recipeId, int userId, bool isAdmin) {
    final recipe = getRecipeById(recipeId);
    if (recipe == null) return false;
    return isAdmin || recipe.userId == userId;
  }

  /// Checks if the user can delete a recipe
  bool canDeleteRecipe(int recipeId, int userId, bool isAdmin) {
    return canEditRecipe(recipeId, userId, isAdmin);
  }

  /// Loads recipes with permission data from backend
  Future<void> loadRecipesWithPermissions(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final recipeMaps =
          await ApiService.getRecipesWithPermissions(userId);
      _recipes =
          recipeMaps.map((json) => Recipe.fromJson(json)).toList();

      _syncFavoriteStatus();
    } catch (e) {
      _error = 'Failed to load recipes';
      debugPrint('❌ RecipeProvider load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------- Delete Recipe --------------------

  /// Deletes a recipe from backend and local state
  Future<bool> deleteRecipe(int recipeId, int userId) async {
    try {
      final success =
          await ApiService.deleteRecipe(recipeId, userId);

      if (success) {
        _recipes.removeWhere((r) => r.id == recipeId);
        _userFavorites.removeWhere((r) => r.id == recipeId);
        notifyListeners();
      }

      return success;
    } catch (e) {
      debugPrint('❌ Error deleting recipe: $e');
      return false;
    }
  }
}


