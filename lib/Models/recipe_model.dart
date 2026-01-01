// Import Dart library for JSON encoding and decoding
import 'dart:convert';

// Import Flutter material package (used for annotations or UI-related needs)
import 'package:flutter/material.dart';

/// Recipe model class
/// Represents a single recipe object in the application
class Recipe {
  // Unique identifier for the recipe
  final int id;

  // Name of the recipe
  final String name;

  // Name of the recipe author
  final String authorName;

  // Category of the recipe (e.g., Main Course, Dessert)
  final String category;

  // Cooking duration of the recipe
  final String cookingTime;

  // Calorie information
  final String calories;

  // Path or URL of the recipe image
  final String imagePath;

  // List of ingredients used in the recipe
  final List<String> ingredients;

  // Step-by-step cooking instructions
  final List<String> steps;

  // Moods/emotions associated with the recipe
  final List<String> moods;

  // ID of the user who created the recipe
  final int userId;

  // Indicates whether the recipe is marked as favorite
  final bool isFavorite;

  // Indicates whether the current user can edit the recipe
  final bool canEdit;

  // Indicates whether the current user can delete the recipe
  final bool canDelete;

  /// Constructor for creating a Recipe object
  Recipe({
    required this.id,
    required this.name,
    required this.authorName,
    required this.category,
    required this.cookingTime,
    required this.calories,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
    required this.moods,
    required this.userId,
    this.isFavorite = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  /// Factory constructor to create a Recipe object from JSON data
  /// Handles different backend response formats safely
  factory Recipe.fromJson(Map<String, dynamic> json) {

    /// Helper function to parse backend data that may be:
    /// - null
    /// - a List
    /// - a JSON-encoded String
    List<String> parseBackendData(dynamic data) {
      if (data == null) return [];

      if (data is List) {
        return List<String>.from(data);
      }

      if (data is String) {
        try {
          final parsed = jsonDecode(data);
          if (parsed is List) {
            return List<String>.from(parsed);
          }
          return [];
        } catch (e) {
          // Return empty list if parsing fails
          return [];
        }
      }
      return [];
    }

    /// Parses ingredient names coming as a comma-separated string
    List<String> parseIngredients() {
      final ingredientNames = json['ingredient_names'];

      if (ingredientNames == null || ingredientNames == 'null') return [];

      final names = ingredientNames.toString();
      if (names.isEmpty) return [];

      // Split ingredients by comma and remove extra spaces
      return names
          .split(',')
          .map((name) => name.trim())
          .toList();
    }

    // Create and return a Recipe object
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      authorName: json['author_name'] ?? '',
      category: json['category_name'] ?? json['category'] ?? 'Main Course',
      cookingTime: json['cooking_time'] ?? json['time'] ?? '30 mins',
      calories: json['calories']?.toString() ?? '0',
      imagePath:
          json['image_path'] ?? json['image'] ?? 'assets/recipes/test.png',
      ingredients: parseIngredients(),
      steps: parseBackendData(json['steps'] ?? json['instructions']),
      moods: parseBackendData(json['emotions'] ?? json['mood']),
      userId: json['user_id'] ?? json['userId'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  /// Determines if the current user is allowed to edit the recipe
  /// Admins or recipe owners can edit
  bool canUserEdit(int currentUserId, bool isAdmin) {
    return isAdmin || userId == currentUserId;
  }

  /// Determines if the current user is allowed to delete the recipe
  /// Admins or recipe owners can delete
  bool canUserDelete(int currentUserId, bool isAdmin) {
    return isAdmin || userId == currentUserId;
  }

  /// Creates a copy of the Recipe object with updated values
  /// Used for immutable state updates
  Recipe copyWith({
    int? id,
    String? name,
    String? authorName,
    String? category,
    String? cookingTime,
    String? calories,
    String? imagePath,
    List<String>? ingredients,
    List<String>? steps,
    List<String>? moods,
    int? userId,
    bool? isFavorite,
    bool? canEdit,
    bool? canDelete,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      authorName: authorName ?? this.authorName,
      category: category ?? this.category,
      cookingTime: cookingTime ?? this.cookingTime,
      calories: calories ?? this.calories,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      moods: moods ?? this.moods,
      userId: userId ?? this.userId,
      isFavorite: isFavorite ?? this.isFavorite,
      canEdit: canEdit ?? this.canEdit,
      canDelete: canDelete ?? this.canDelete,
    );
  }

  /// Converts a Recipe object back to JSON format
  /// Used when sending data to the backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'authorName': authorName,
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

