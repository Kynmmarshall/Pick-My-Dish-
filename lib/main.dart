import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

void main() {
  runApp(const PickMyDish());
}

class PickMyDish extends StatelessWidget {
  const PickMyDish({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// Constants
bool isPasswordVisible = false;

const double iconSize = 40;

const title = TextStyle(
  color: Colors.white,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 37,
);

const mediumtitle = TextStyle(
  color: Colors.white,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 23,
);

const footer = TextStyle(
  color: Colors.white,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 22,
);

const footerClickable = TextStyle(
  color: Colors.orange,
  fontFamily: 'TimesNewRoman',
  fontWeight: FontWeight.w600,
  fontSize: 22,
);

const text = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 18,
);

const caloriesText = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Colors.white,
  fontSize: 14,
);

const categoryText = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Colors.orange,
  fontSize: 16,
);

const placeHolder = TextStyle(
  fontFamily: 'TimesNewRoman',
  color: Color.fromARGB(193, 255, 255, 255),
  fontSize: 20,
);

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset('assets/logo/logo.png')));
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      //logo
                      Image.asset('assets/login/logo.png'),

                      const SizedBox(height: 10),

                      Text("PICK MY DISH", style: title),

                      Text("Cook in easy way", style: text),

                      const SizedBox(height: 5),

                      Text("Login", style: title),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: text,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: placeHolder,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.key,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: text,
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: placeHolder,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to login screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password? ",
                              style: footerClickable,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.g_mobiledata,
                          color: Colors.red,
                          size: iconSize,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Registration logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Your color
                          side: const BorderSide(color: Colors.white, width: 2),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text("Login", style: title),
                      ),

                      const SizedBox(height: 100),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Not Registered Yet? ", style: footer),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to login screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Register Now",
                                  style: footerClickable,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Register Screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      //logo
                      Image.asset('assets/login/logo.png'),

                      const SizedBox(height: 10),

                      Text("PICK MY DISH", style: title),

                      Text("Cook in easy way", style: text),

                      const SizedBox(height: 5),

                      Text("Register", style: title),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: text,
                              decoration: InputDecoration(
                                hintText: "Full Name",
                                hintStyle: placeHolder,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: text,
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: placeHolder,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.key,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: text,
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: placeHolder,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          const Icon(
                            Icons.key,
                            color: Colors.white,
                            size: iconSize,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: text,
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: placeHolder,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.g_mobiledata,
                          color: Colors.red,
                          size: iconSize,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          // Registration logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Your color
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text("Register", style: title),
                      ),

                      const SizedBox(height: 100),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already Registered? ", style: footer),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to login screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login Now",
                                  style: footerClickable,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Home Screen
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
  List<String> ingredients = [
    'Eggs',
    'Flour',
    'Chicken',
    'Vegetables',
    'Rice',
    'Pasta',
    'Cheese',
    'Milk',
  ];
  List<String> timeOptions = ['15 mins', '30 mins', '1 hour', '2+ hours'];
  String ingredientSearch = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildSideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30),
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Image.asset(
              'assets/icons/hamburger.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF6B6B6B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Welcome Section
                    Row(children: [Text("Welcome", style: title)]),
                    const SizedBox(height: 8),
                    Text(
                      "What would you like to cook today?",
                      style: title.copyWith(color: Colors.orange),
                    ),
                    const SizedBox(height: 30),

                    // Personalization Section
                    _buildPersonalizationSection(),
                    const SizedBox(height: 30),

                    // Today's Fresh Recipe
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Fresh Recipe",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecipesScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Recipe Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5, // Since you have 2 cards
                      itemBuilder: (context, index) {
                        final recipe = RecipesScreenState.allRecipes[index];
                        return Column(
                          children: [
                            buildRecipeCard(recipe),
                            const SizedBox(
                              height: 20,
                            ), // Adds space after each item except last
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personalize Your Recipes", style: mediumtitle),
          const SizedBox(height: 15),

          // Emotion Dropdown
          DropdownButtonFormField<String>(
            value: selectedEmotion,
            decoration: InputDecoration(
              labelText: "How are you feeling?",
              labelStyle: const TextStyle(color: Colors.white70),
              border: const OutlineInputBorder(),
            ),
            items: emotions.map((emotion) {
              return DropdownMenuItem(
                value: emotion,
                child: Text(
                  emotion,
                  style: const TextStyle(color: Colors.orange),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedEmotion = value;
              });
            },
          ),
          const SizedBox(height: 15),

          // Ingredients Selection
          DropdownSearch<String>.multiSelection(
            items: ingredients,
            popupProps: const PopupPropsMultiSelection.menu(
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
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: "Select ingredients",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Time Selection
          DropdownButtonFormField<String>(
            value: selectedTime,
            decoration: InputDecoration(
              labelText: "Cooking Time",
              labelStyle: const TextStyle(color: Colors.white70),
              border: const OutlineInputBorder(),
            ),
            items: timeOptions.map((time) {
              return DropdownMenuItem(
                value: time,
                child: Text(time, style: const TextStyle(color: Colors.orange)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTime = value;
              });
            },
          ),
          const SizedBox(height: 15),

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
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text("Generate Personalized Recipes", style: text),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecipeCard(Map<String, dynamic> recipe) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF373737),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Recipe Image
          Positioned(
            left: 20,
            top: 5,
            child: Container(
              width: 66,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(recipe['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Recipe Name
          Positioned(
            left: 100,
            top: 13,
            child: Text(
              recipe['name'],
              style: const TextStyle(
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
                const Icon(Icons.access_time, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text(
                  recipe['time'],
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Like Icon - Clickable
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  recipe['isFavorite'] = !recipe['isFavorite'];
                });
              },
              child: Icon(
                recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                color: Colors.orange,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/sideMenu/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),

          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.orange,
                        size: iconSize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Profile Section
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/login/noPicture.png',
                      ), // Replace with profile image
                    ),
                    const SizedBox(width: 25),
                    Text("kynmmarshall", style: title.copyWith(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: Text("View Profile", style: footerClickable),
                ),

                const SizedBox(height: 50),

                // Menu Items
                _buildMenuItem(Icons.home, "Home", () {
                  Navigator.pop(context);
                }),
                const SizedBox(height: 20),
                _buildMenuItem(Icons.favorite, "Favorites", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                _buildMenuItem(Icons.help, "Help", () {
                  Navigator.pop(context);
                }),
                const Spacer(),
                _buildMenuItem(Icons.logout, "Logout", () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 32),
      title: Text(title, style: text.copyWith(fontSize: 22)),
      onTap: () => onTap(),
      contentPadding: EdgeInsets.zero,
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

// Recipes Screen
class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => RecipesScreenState();
}

class RecipesScreenState extends State<RecipesScreen> {
  static List<Map<String, dynamic>> allRecipes = [
    {
      'category': 'Breakfast',
      'name': 'Toast with Berries',
      'time': '10:03',
      'isFavorite': false,
      'image': 'assets/recipes/test.png',
      'calories': '1003',
    },
    {
      'category': 'Dinner',
      'name': 'Chicken Burger',
      'time': '25:30',
      'isFavorite': true,
      'image': 'assets/recipes/test.png',
      'calories': '2008',
    },
    {
      'category': 'Dinner',
      'name': 'Chicken Burger',
      'time': '25:30',
      'isFavorite': true,
      'image': 'assets/recipes/test.png',
      'calories': '2008',
    },
    {
      'category': 'Breakfast',
      'name': 'Toast with Berries',
      'time': '10:03',
      'isFavorite': false,
      'image': 'assets/recipes/test.png',
      'calories': '1003',
    },
    {
      'category': 'Dinner',
      'name': 'Chicken Burger',
      'time': '25:30',
      'isFavorite': true,
      'image': 'assets/recipes/test.png',
      'calories': '2008',
    },
    {
      'category': 'Dinner',
      'name': 'Chicken Burger',
      'time': '25:30',
      'isFavorite': true,
      'image': 'assets/recipes/test.png',
      'calories': '2008',
    },
    {
      'category': 'Dinner',
      'name': 'Chicken Burger',
      'time': '25:30',
      'isFavorite': true,
      'image': 'assets/recipes/test.png',
      'calories': '2008',
    },
    // Add more recipes here
  ];

  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
    });
  }

  List<Map<String, dynamic>> get filteredRecipes {
    if (searchQuery.isEmpty) return allRecipes;
    return allRecipes.where((recipe) {
      return recipe['name'].toLowerCase().contains(searchQuery) ||
          recipe['category'].toLowerCase().contains(searchQuery);
    }).toList();
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Header with title and back button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Recipes", style: title.copyWith(fontSize: 28)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.orange,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    const Icon(Icons.search, color: Colors.white70),
                    const SizedBox(width: 10),
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
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recipes Grid
              Expanded(
                child: filteredRecipes.isEmpty
                    ? Center(child: Text("No recipes found", style: title))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          return buildRecipeCard(filteredRecipes[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecipeCard(Map<String, dynamic> recipe) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Recipe Image
          Positioned(
            top: 20,
            right: 10,
            child: Container(
              width: 99,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(recipe['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Favorite Icon
          Positioned(
            top: 10,
            left: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  recipe['isFavorite'] = !recipe['isFavorite'];
                });
              },
              child: Icon(
                recipe['isFavorite'] ? Icons.favorite : Icons.favorite_border,
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
                  recipe['category'],
                  style: categoryText.copyWith(
                    color: const Color(0xFF2958FF),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),

                // Recipe Name
                Text(recipe['name'], style: text.copyWith(fontSize: 17)),
                const SizedBox(height: 10),

                // Time with Icon
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      recipe['time'],
                      style: const TextStyle(
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
    );
  }
}

// Favorites Screen
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = RecipesScreenState.allRecipes
        .where((recipe) => recipe['isFavorite'] == true)
        .toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Favorite Recipes", style: title.copyWith(fontSize: 28)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Favorites List
              Expanded(
                child: favoriteRecipes.isEmpty
                    ? Center(
                        child: Text("No favorite recipes yet", style: text),
                      )
                    : ListView.builder(
                        itemCount: favoriteRecipes.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: _buildRecipeCard(favoriteRecipes[index]),
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

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF373737),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(0, 5),
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
              width: 66,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(recipe['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Recipe Name
          Positioned(
            left: 100,
            top: 13,
            child: Text(
              recipe['name'],
              style: const TextStyle(
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
                const Icon(Icons.access_time, color: Colors.orange, size: 12),
                const SizedBox(width: 5),
                Text(
                  recipe['time'],
                  style: const TextStyle(
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
            child: const Icon(Icons.favorite, color: Colors.orange, size: 20),
          ),
        ],
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "kynmmarshall";
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 50,
              left: 30,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.orange,
                  size: iconSize,
                ),
              ),
            ),

            // Main Content
            Center(
              child: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image with Edit Icon
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            'assets/login/noPicture.png',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Username Text Field
                    TextField(
                      controller: usernameController,
                      style: text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: placeHolder,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Upload Button
                    ElevatedButton(
                      onPressed: () {
                        // Upload Profile Info logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        "Confirm",
                        style: text.copyWith(fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
