import 'package:flutter/material.dart';
import 'package:pick_my_dish/Models/recipe_model.dart';
import 'package:pick_my_dish/Providers/recipe_provider.dart';
import 'package:pick_my_dish/Providers/user_provider.dart';
import 'package:pick_my_dish/Screens/recipe_detail_screen.dart';
import 'package:pick_my_dish/constants.dart';
import 'package:pick_my_dish/widgets/cached_image.dart';
import 'package:provider/provider.dart';

/// FavoritesScreen
/// Displays all recipes marked as favorites by the user.
/// Supports:
/// - Loading favorites from API
/// - Removing favorites
/// - Pull-to-refresh
/// - Empty states (logged out / no favorites)
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  // Indicates whether favorites are currently loading
  bool _isLoading = false;

  // Ensures favorites load only once when dependencies change
  bool _hasLoaded = false;

  /// Loads the user's favorite recipes from the API
  Future<void> _loadFavorites() async {
    if (_isLoading || !mounted) return;

    setState(() => _isLoading = true);

    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // If user is not logged in, stop loading
    if (userProvider.userId == 0) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      // Small delay prevents widget build conflicts
      await Future.delayed(const Duration(milliseconds: 10));
      await recipeProvider.loadUserFavorites(userProvider.userId);
    } catch (e) {
      debugPrint('❌ Error loading favorites: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    // Load favorites after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Prevent reloading favorites on every dependency change
    if (!_hasLoaded) {
      _hasLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadFavorites();
      });
    }
  }

  /// Opens the recipe detail screen
  void _showRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipeDetailScreen(initialRecipe: recipe),
      ),
    );
  }

  /// Removes a recipe from favorites with confirmation
  Future<void> _removeFavorite(Recipe recipe) async {
    final recipeProvider =
        Provider.of<RecipeProvider>(context, listen: false);
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);

    // Prevent action if user is not logged in
    if (userProvider.userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please login to manage favorites',
            style: text,
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Confirm removal
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from favorites?', style: title),
        content: Text(
          'Remove "${recipe.name}" from your favorites?',
          style: text,
        ),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                Text('Cancel', style: text.copyWith(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                Text('Remove', style: text.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );

    // Remove and refresh favorites
    if (shouldRemove == true && mounted) {
      await recipeProvider.toggleFavorite(
          userProvider.userId, recipe.id);
      await _loadFavorites();
    }
  }

  /// Displays empty state UI depending on login status
  Widget _buildEmptyState() {
    final userProvider = Provider.of<UserProvider>(context);

    // User not logged in
    if (userProvider.userId == 0) {
      return _buildMessage(
        icon: Icons.favorite_border,
        titleText: 'Login to save favorites',
        message:
            'Your favorite recipes will appear here',
        buttonText: 'Go Home',
      );
    }

    // No favorites yet
    return _buildMessage(
      icon: Icons.favorite_border,
      titleText: 'No favorite recipes yet',
      message:
          'Tap the heart icon on any recipe to add it here',
      buttonText: 'Browse Recipes',
    );
  }

  /// Reusable empty-state widget
  Widget _buildMessage({
    required IconData icon,
    required String titleText,
    required String message,
    required String buttonText,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 60),
          const SizedBox(height: 20),
          Text(titleText,
              style: title.copyWith(fontSize: 20)),
          const SizedBox(height: 10),
          Text(
            message,
            style: text.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text(buttonText, style: text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final favoriteRecipes = recipeProvider.favorites;

    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Favorite Recipes",
                    style: title.copyWith(fontSize: 28)),
                Row(
                  children: [
                    if (favoriteRecipes.isNotEmpty)
                      Text(
                        '(${favoriteRecipes.length})',
                        style: title.copyWith(
                          fontSize: 18,
                          color: Colors.orange,
                        ),
                      ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Logged-in user info
            if (userProvider.userId != 0)
              Row(
                children: [
                  const Icon(Icons.person,
                      color: Colors.orange, size: 25),
                  const SizedBox(width: 8),
                  Text(
                    userProvider.username,
                    style: text.copyWith(
                      fontSize: 17,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Colors.orange),
                    )
                  : favoriteRecipes.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadFavorites,
                          color: Colors.orange,
                          backgroundColor: Colors.black,
                          child: ListView.builder(
                            itemCount: favoriteRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = favoriteRecipes[index];
                              return GestureDetector(
                                onTap: () =>
                                    _showRecipeDetails(recipe),
                                onLongPress: () =>
                                    _removeFavorite(recipe),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child:
                                      _buildRecipeCard(recipe),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single recipe card UI
  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF373737),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Recipe Image
          Positioned(
            left: 8,
            top: 8,
            child: CachedProfileImage(
              imagePath: recipe.imagePath,
              width: 84,
              height: 84,
              radius: 8,
              fit: BoxFit.cover,
            ),
          ),

          // Recipe Name
          Positioned(
            left: 105,
            top: 15,
            right: 50,
            child: Text(
              recipe.name,
              style: const TextStyle(
                fontFamily: 'Lora',
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Cooking Time
          Positioned(
            left: 105,
            bottom: 15,
            child: Row(
              children: [
                const Icon(Icons.access_time,
                    color: Colors.orange, size: 12),
                const SizedBox(width: 5),
                Text(
                  recipe.cookingTime,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Remove Favorite Button
          Positioned(
            right: 15,
            top: 15,
            child: IconButton(
              icon: const Icon(Icons.favorite,
                  color: Colors.orange),
              onPressed: () => _removeFavorite(recipe),
            ),
          ),
        ],
      ),
    );
  }
}


