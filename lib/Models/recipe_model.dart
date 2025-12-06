import 'dart:convert';
class Recipe {
  final int id;
  final String name;
  final String category;
  final String cookingTime;
  final String calories;
  final String imagePath;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> moods;
  final int userId;
  final bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.cookingTime,
    required this.calories,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
    required this.moods,
    required this.userId,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
  // Helper function to safely parse JSON strings
  List<String> parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) return List<String>.from(data);
    if (data is String) {
      try {
        return List<String>.from(jsonDecode(data));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  return Recipe(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    category: json['category'] ?? 'Uncategorized',
    cookingTime: json['time'] ?? json['cooking_time'] ?? '0 mins',
    calories: json['calories']?.toString() ?? '0',
    imagePath: json['image_path'] ?? json['image'] ?? 'assets/recipes/test.png',
    ingredients: parseList(json['ingredients']),
    steps: parseList(json['steps']),
    moods: parseList(json['mood'] ?? json['emotions']),
    userId: json['user_id'] ?? 0,
    isFavorite: json['isFavorite'] ?? false,
  );
}
  Recipe copyWith({
    int? id,
    String? name,
    String? category,
    String? cookingTime,
    String? calories,
    String? imagePath,
    List<String>? ingredients,
    List<String>? steps,
    List<String>? moods,
    int? userId,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      cookingTime: cookingTime ?? this.cookingTime,
      calories: calories ?? this.calories,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      moods: moods ?? this.moods,
      userId: userId ?? this.userId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'time': cookingTime,
      'calories': calories,
      'image_path': imagePath,
      'ingredients': ingredients,
      'instructions': steps,
      'mood': moods,
      'userId': userId,
      'isFavorite': isFavorite,
    };
  }
}