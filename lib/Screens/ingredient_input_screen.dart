import 'package:flutter/material.dart';
import 'package:pick_my_dish/Models/recipe_model.dart';
import 'package:pick_my_dish/Services/database_service.dart';
import 'package:pick_my_dish/Screens/recipe_detail_screen.dart';
import 'package:pick_my_dish/constants.dart';
import 'package:pick_my_dish/widgets/cached_image.dart';

class IngredientInputScreen extends StatefulWidget {
  const IngredientInputScreen({super.key});

  @override
  State<IngredientInputScreen> createState() => _IngredientInputScreenState();
}

class _IngredientInputScreenState extends State<IngredientInputScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _enteredIngredients = [];
  List<Recipe> _matchingRecipes = [];
  bool _isLoading = false;
  bool _showSuggestions = true;
  final DatabaseService _databaseService = DatabaseService();
  final FocusNode _focusNode = FocusNode();

  // Popular ingredient suggestions
  final List<String> _ingredientSuggestions = [
    'chicken',
    'beef',
    'eggs',
    'milk',
    'cheese',
    'butter',
    'flour',
    'rice',
    'pasta',
    'tomatoes',
    'onions',
    'garlic',
    'potatoes',
    'carrots',
    'bell peppers',
    'mushrooms',
    'spinach',
    'broccoli',
    'olive oil',
    'soy sauce',
    'salt',
    'pepper',
    'sugar',
    'lemon',
    'lime',
    'cilantro',
    'basil',
    'thyme',
    'ginger',
    'turmeric',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final ingredient = _ingredientController.text.trim().toLowerCase();
    if (ingredient.isNotEmpty && !_enteredIngredients.contains(ingredient)) {
      setState(() {
        _enteredIngredients.add(ingredient);
        _ingredientController.clear();
        _showSuggestions = false;
      });
    }
  }

  void _addSuggestion(String ingredient) {
    if (!_enteredIngredients.contains(ingredient)) {
      setState(() {
        _enteredIngredients.add(ingredient);
        _showSuggestions = false;
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _enteredIngredients.removeAt(index);
    });
  }

  Future<void> _findRecipes() async {
    if (_enteredIngredients.isEmpty) {
      _showSnackBar('Please add at least one ingredient');
      return;
    }

    setState(() {
      _isLoading = true;
      _matchingRecipes.clear();
      _showSuggestions = false;
    });

    try {
      final recipes = await _databaseService.getFilteredRecipes(
        ingredients: _enteredIngredients,
      );

      // Sort recipes by match count (highest first)
      recipes.sort((a, b) {
        final aMatches = _countMatchingIngredients(a.ingredients);
        final bMatches = _countMatchingIngredients(b.ingredients);
        return bMatches.compareTo(aMatches);
      });

      setState(() {
        _matchingRecipes = recipes;
        _isLoading = false;
      });

      if (recipes.isEmpty) {
        _showNoRecipesDialog();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error finding recipes: ${e.toString()}');
    }
  }

  int _countMatchingIngredients(List<String> recipeIngredients) {
    int count = 0;
    for (final userIngredient in _enteredIngredients) {
      for (final recipeIngredient in recipeIngredients) {
        if (_ingredientsMatch(userIngredient, recipeIngredient)) {
          count++;
          break;
        }
      }
    }
    return count;
  }

  bool _ingredientsMatch(String userIngredient, String recipeIngredient) {
    final user = userIngredient.toLowerCase();
    final recipe = recipeIngredient.toLowerCase();

    // Check for direct match or substring match
    return recipe.contains(user) || user.contains(recipe);
  }

  void _showNoRecipesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.orange, width: 2),
        ),
        title: Text(
          'No Recipes Found',
          style: title.copyWith(fontSize: 24, color: Colors.orange),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: Colors.orange, size: 60),
            SizedBox(height: 20),
            Text(
              'We couldn\'t find any recipes with your ingredients.',
              style: text.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Try adding more common ingredients like:',
              style: text.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: ['chicken', 'rice', 'eggs', 'tomatoes'].map((ing) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Text(
                    ing,
                    style: text.copyWith(fontSize: 12, color: Colors.orange),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text('OK', style: text.copyWith(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _enteredIngredients.clear();
      _matchingRecipes.clear();
      _showSuggestions = true;
    });
  }

  void _showRecipeDetails(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: text),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildIngredientChip(String ingredient, int index) {
    return Chip(
      label: Text(ingredient, style: text.copyWith(fontSize: 14)),
      deleteIcon: Icon(Icons.close, size: 18, color: Colors.orange),
      onDeleted: () => _removeIngredient(index),
      backgroundColor: Colors.orange.withOpacity(0.15),
      shape: StadiumBorder(
        side: BorderSide(color: Colors.orange.withOpacity(0.5)),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildSuggestionChip(String ingredient) {
    return ActionChip(
      label: Text(ingredient, style: text.copyWith(fontSize: 14)),
      onPressed: () => _addSuggestion(ingredient),
      backgroundColor: Colors.white.withOpacity(0.1),
      shape: StadiumBorder(
        side: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final matchingIngredients = _getMatchingIngredients(recipe.ingredients);
    final matchCount = matchingIngredients.length;
    final totalUserIngredients = _enteredIngredients.length;
    final matchPercentage = totalUserIngredients == 0
        ? 0
        : ((matchCount / totalUserIngredients) * 100).toInt();

    return GestureDetector(
      onTap: () => _showRecipeDetails(recipe),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade800, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image and Basic Info
            Stack(
              children: [
                // Recipe Image
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: AssetImage(recipe.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Gradient Overlay
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Match Badge
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          '$matchPercentage% match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recipe Info
                Positioned(
                  bottom: 15,
                  left: 15,
                  right: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lora',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 5),
                          Text(
                            recipe.cookingTime,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 15),
                          Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${recipe.calories} cal',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
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

            // Recipe Details
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ingredient Match',
                            style: text.copyWith(fontSize: 14),
                          ),
                          Text(
                            '$matchCount/$totalUserIngredients',
                            style: text.copyWith(
                              fontSize: 14,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: matchCount / totalUserIngredients,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        color: Colors.orange,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),

                  // Matching Ingredients
                  if (matchingIngredients.isNotEmpty) ...[
                    SizedBox(height: 15),
                    Text(
                      'Matching Ingredients:',
                      style: text.copyWith(fontSize: 14, color: Colors.white70),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: matchingIngredients.take(4).map((ingredient) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            ingredient,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (matchingIngredients.length > 4)
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          '+ ${matchingIngredients.length - 4} more',
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ),
                  ],

                  // View Recipe Button
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showRecipeDetails(recipe),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View Recipe',
                            style: text.copyWith(fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getMatchingIngredients(List<String> recipeIngredients) {
    final List<String> matches = [];
    for (final userIngredient in _enteredIngredients) {
      for (final recipeIngredient in recipeIngredients) {
        if (_ingredientsMatch(userIngredient, recipeIngredient)) {
          matches.add(recipeIngredient);
          break;
        }
      }
    }
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF2D2D2D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                    Text(
                      "What's in your fridge?",
                      style: title.copyWith(fontSize: 24),
                    ),
                    SizedBox(width: 40), // For balance
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Enter ingredients you have to find recipes you can make",
                  style: text.copyWith(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 25),

                // Input Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add Ingredients", style: mediumtitle),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ingredientController,
                                focusNode: _focusNode,
                                style: text,
                                decoration: InputDecoration(
                                  hintText: "e.g., chicken, tomatoes, rice...",
                                  hintStyle: placeHolder,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                  suffixIcon:
                                      _ingredientController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.white70,
                                          ),
                                          onPressed: () =>
                                              _ingredientController.clear(),
                                        )
                                      : null,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _showSuggestions = value.isNotEmpty;
                                  });
                                },
                                onSubmitted: (_) => _addIngredient(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange,
                              ),
                              child: IconButton(
                                onPressed: _addIngredient,
                                icon: Icon(Icons.add, color: Colors.white),
                                splashRadius: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Press Enter or tap + to add ingredient",
                          style: text.copyWith(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Suggestions
                if (_showSuggestions && _ingredientController.text.isEmpty) ...[
                  SizedBox(height: 20),
                  Text("Quick Add", style: mediumtitle.copyWith(fontSize: 16)),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ingredientSuggestions.take(10).map((ingredient) {
                      return _buildSuggestionChip(ingredient);
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],

                // Entered Ingredients
                if (_enteredIngredients.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Ingredients (${_enteredIngredients.length})",
                        style: mediumtitle.copyWith(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: _clearAll,
                        child: Text(
                          "Clear All",
                          style: text.copyWith(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _enteredIngredients.asMap().entries.map((entry) {
                      return _buildIngredientChip(entry.value, entry.key);
                    }).toList(),
                  ),
                  SizedBox(height: 25),
                ],

                // Find Recipes Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _findRecipes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      disabledBackgroundColor: Colors.orange.withOpacity(0.5),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, size: 22),
                              SizedBox(width: 10),
                              Text(
                                "Find Recipes",
                                style: title.copyWith(fontSize: 20),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 20),

                // Results Section
                Expanded(child: _buildResultsSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 20),
            Text(
              "Searching for recipes...",
              style: text.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 5),
            Text(
              "Finding the best matches for your ingredients",
              style: text.copyWith(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (_matchingRecipes.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recipes You Can Make",
                style: mediumtitle.copyWith(fontSize: 18),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_matchingRecipes.length} found",
                  style: text.copyWith(fontSize: 12, color: Colors.orange),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _matchingRecipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeCard(_matchingRecipes[index]);
              },
            ),
          ),
        ],
      );
    }

    if (_enteredIngredients.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: Colors.white.withOpacity(0.3),
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Ready to find recipes?",
              style: text.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              "Tap 'Find Recipes' to discover",
              style: text.copyWith(color: Colors.white, fontSize: 14),
            ),
            Text(
              "what you can make!",
              style: text.copyWith(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.kitchen, color: Colors.white.withOpacity(0.3), size: 80),
          SizedBox(height: 20),
          Text(
            "What's in your kitchen?",
            style: text.copyWith(color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            "Add ingredients from your fridge",
            style: text.copyWith(color: Colors.white, fontSize: 14),
          ),
          Text(
            "to find delicious recipes",
            style: text.copyWith(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Text(
                  "💡 Tip:",
                  style: text.copyWith(color: Colors.orange, fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  "Start with basic ingredients like:",
                  style: text.copyWith(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: ['chicken', 'eggs', 'rice', 'tomatoes', 'onions']
                      .map((ing) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            ing,
                            style: text.copyWith(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
