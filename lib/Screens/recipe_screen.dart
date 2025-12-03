import 'package:flutter/material.dart';
import 'package:pick_my_dish/Screens/favorite_screen.dart';
import 'package:pick_my_dish/Screens/recipe_upload_screen.dart';
import 'package:pick_my_dish/Services/api_service.dart';
import 'package:pick_my_dish/constants.dart';
import 'package:pick_my_dish/Screens/recipe_detail_screen.dart';
import 'package:pick_my_dish/widgets/cached_image.dart';
import 'package:pick_my_dish/widgets/cached_image.dart'; // Add this

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => RecipesScreenState();
}

class RecipesScreenState extends State<RecipesScreen> {
  List<Map<String, dynamic>> allRecipes = [];
  bool isLoading = true;
  bool hasError = false;

  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final recipes = await ApiService.getRecipes();
      setState(() {
        allRecipes = recipes;
        isLoading = false;
        hasError = false;
      });
    } catch (e) {
      print('❌ Error loading recipes: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
    });
  }

  List<Map<String, dynamic>> get filteredRecipes {
    if (searchQuery.isEmpty) return allRecipes;
    return allRecipes.where((recipe) {
      return recipe['name']?.toLowerCase().contains(searchQuery) ?? false ||
          recipe['category']?.toLowerCase().contains(searchQuery) ?? false;
    }).toList();
  }

  void _showRecipeDetails(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 20),
            child: Row(
              children: [
                // Add Recipe Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipeUploadScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/icons/add.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 10),

                // Favorites Icon
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/icons/heart.png', // You'll need to add this icon
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 10), // Adjust spacing
              ],
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: 50),
              // Header with title and back button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Recipes", style: title.copyWith(fontSize: 28)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.orange,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Search Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    Icon(Icons.search, color: Colors.white70),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: text,
                        decoration: InputDecoration(
                          hintText: "Search recipes...",
                          hintStyle: placeHolder,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Loading/Error/Recipes
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadRecipes,
        backgroundColor: Colors.orange,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.orange));
    }
    
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 50),
            SizedBox(height: 20),
            Text('Failed to load recipes', style: text),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadRecipes,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (filteredRecipes.isEmpty) {
      return Center(
        child: Text(
          searchQuery.isEmpty ? 'No recipes available' : 'No recipes found',
          style: title,
        ),
      );
    }
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        return buildRecipeCard(filteredRecipes[index]);
      },
    );
  }

  Widget buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () => _showRecipeDetails(recipe),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Recipe Image from VPS database
            Positioned(
              top: 20,
              right: 10,
              child: Container(
                width: 99,
                height: 87,
                child: CachedProfileImage(
                  imagePath: recipe['image_path'] ?? 'assets/recipes/test.png',
                  radius: 0,
                  isProfilePicture: false,
                  width: 99,
                  height: 87,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Favorite Icon
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  _toggleFavorite(recipe);
                },
                child: Icon(
                  (recipe['isFavorite'] == true) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.orange,
                  size: iconSize,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Category
                  Text(
                    recipe['category'] ?? 'Uncategorized',
                    style: categoryText.copyWith(
                      color: Color(0xFF2958FF),
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),

                  // Recipe Name
                  Text(
                    recipe['name'] ?? 'Unknown Recipe',
                    style: text.copyWith(fontSize: 17),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),

                  // Time with Icon
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 16),
                      SizedBox(width: 5),
                      Text(
                        recipe['cooking_time'] ?? '0 mins',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> recipe) {
    // Add favorite logic to API
    // For now, just update UI
    setState(() {
      recipe['isFavorite'] = !(recipe['isFavorite'] == true);
    });
    
    // TODO: Call API to update favorite status in database
    // ApiService.toggleFavorite(recipe['id'], recipe['isFavorite']);
  }
}