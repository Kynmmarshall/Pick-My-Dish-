import 'package:flutter/material.dart';
import 'package:pick_my_dish/Models/recipe_model.dart';
import 'package:pick_my_dish/Providers/recipe_provider.dart';
import 'package:pick_my_dish/Screens/recipe_detail_screen.dart';
import 'package:pick_my_dish/constants.dart';
import 'package:pick_my_dish/widgets/cached_image.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoriteRecipes = recipeProvider.favorites;

    void _showRecipeDetails(Recipe recipe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(initialRecipe: recipe), // Convert to Map for compatibility
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: 30),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Favorite Recipes", style: title.copyWith(fontSize: 28)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Favorites List
              Expanded(
                child: favoriteRecipes.isEmpty
                    ? Center(
                        child: Text("No favorite recipes yet", style: text),
                      )
                    : ListView.builder(
                        itemCount: favoriteRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = favoriteRecipes[index];
                          return GestureDetector(
                            onTap: () {
                              _showRecipeDetails(recipe);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: _buildRecipeCard(recipe),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFF373737),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Recipe Image
          Positioned(
            left: 4,
            top: 5,
            child: Container(
                width: 99,
                height: 87,
                child: CachedProfileImage(
                  imagePath: recipe.imagePath, // Use Recipe property
                  radius: 0,
                  isProfilePicture: false,
                  width: 99,
                  height: 87,
                  fit: BoxFit.cover,
                ),
              ),
          ),

          // Recipe Name
          Positioned(
            left: 100,
            top: 13,
            child: Text(
              recipe.name, // Use Recipe model property
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Time with Icon
          Positioned(
            right: 15,
            bottom: 10,
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.orange, size: 12),
                SizedBox(width: 5),
                Text(
                  recipe.cookingTime, // Use Recipe model property
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 9.7,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Favorite Icon (filled since it's favorites screen)
          Positioned(
            right: 10,
            top: 10,
            child: Icon(Icons.favorite, color: Colors.orange, size: 20),
          ),
        ],
      ),
    );
  }
}