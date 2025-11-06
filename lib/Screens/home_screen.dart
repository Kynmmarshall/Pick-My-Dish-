import 'package:flutter/material.dart';
import 'package:pick_my_dish/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedEmotion;
  List<String> selectedIngredients = [];
  String? selectedTime;
  
  List<String> emotions = ['Happy', 'Sad', 'Energetic', 'Comfort', 'Healthy'];
  List<String> ingredients = ['Eggs', 'Flour', 'Chicken', 'Vegetables', 'Rice', 'Pasta', 'Cheese', 'Milk'];
  List<String> timeOptions = ['15 mins', '30 mins', '1 hour', '2+ hours'];
  String ingredientSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color(0xFF6B6B6B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0],
          )
        ),
        child: Stack(
          children: [
            // Hamburger Menu
            Positioned(
              top: 50,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  // Handle menu click
                },
                child: Image.asset(
                  'assets/icons/hamburger.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    
                    // Welcome Section
                    Row(
                      children: [
                        Text(
                          "Welcome",
                           style: title,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "What would you like to cook today?",
                      style: title.copyWith(color: Colors.orange)
                    ),
                    SizedBox(height: 30),

                    // Personalization Section
                    _buildPersonalizationSection(),
                    SizedBox(height: 30),

                    // Today's Fresh Recipe
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Fresh Recipe",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Recipe Cards
                    // Recipe Cards - Responsive layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                
                          return Column(
                            
                            children: [
                              _buildRecipeCard("Breakfast", "Toast with Berries", "1003"),
                              SizedBox(height: 15),
                              _buildRecipeCard("Dinner", "Chicken Burger", "2008"),
                            ],
                          );
                        }
                    ),
                    SizedBox(height: 30),

                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizationSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personalize Your Recipes",
            style:mediumtitle,
          ),
          SizedBox(height: 15),
          
          // Emotion Dropdown
          DropdownButtonFormField<String>(
            value: selectedEmotion,
            decoration: InputDecoration(
              labelText: "How are you feeling?",
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
            ),
            items: emotions.map((emotion) {
              return DropdownMenuItem(
                value: emotion,
                child: Text(emotion, style: TextStyle(color: Colors.orange)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedEmotion = value;
              });
            },
          ),
          SizedBox(height: 15),

          // Ingredients Selection
          DropdownSearch<String>.multiSelection(
          items: ingredients,
          popupProps: PopupPropsMultiSelection.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(hintText: "Search ingredients..."),
            ),
          ),
          onChanged: (List<String> selectedItems) {
            setState(() {
              selectedIngredients = selectedItems;
            });
          },
          selectedItems: selectedIngredients,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              hintText: "Select ingredients",
              border: OutlineInputBorder(),
            ),
          ),
        ),







          SizedBox(height: 15),

          // Time Selection
          DropdownButtonFormField<String>(
            value: selectedTime,
            decoration: InputDecoration(
              labelText: "Cooking Time",
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
            ),
            items: timeOptions.map((time) {
              return DropdownMenuItem(
                value: time,
                child: Text(time, style: TextStyle(color: Colors.orange)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTime = value;
              });
            },
          ),
          SizedBox(height: 15),

          // Generate Recipes Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Generate personalized recipes
                _generateRecipes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                "Generate Personalized Recipes",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(String category, String title, String calories) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            category,
            style: TextStyle(color: Colors.orange, fontSize: 12),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            calories,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _generateRecipes() {
    // Logic to generate recipes based on selections
    print("Emotion: $selectedEmotion");
    print("Ingredients: $selectedIngredients");
    print("Time: $selectedTime");
    
    // Navigate to results screen or show dialog with personalized recipes
  }
}