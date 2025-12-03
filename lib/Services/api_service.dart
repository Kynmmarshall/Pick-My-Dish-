import 'dart:convert';  // For JSON encoding/decoding
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ApiService {
  // Backend server base URL
    
    // For physical device testing:
   //static const String baseUrl = "http://192.168.1.110:3000";
  
  // For production (VPS):
  static const String baseUrl = "http://38.242.246.126:3000";
  
  // Test if backend is reachable and database is connected
  static Future<void> testConnection() async {
    try {
      // Send GET request to test endpoint
      final response = await http.get(Uri.parse('$baseUrl/api/pick_my_dish'));
      debugPrint('Backend status: ${response.statusCode}');  // Should be 200 if successful
      debugPrint('Response: ${response.body}');  // Response data from backend
    } catch (e) {
      debugPrint('Connection error: $e');  // Handle network/database errors
    }
  }


  //login user
  static Future<Map<String, dynamic>?>  login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      final errorData = json.decode(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ Login successful: ${data['message']}');
        debugPrint('👤 User: ${data['user']}');
        return data;
      } else {
        debugPrint('❌ Login failed: ${response.statusCode} - ${response.body}');
        return {'error': errorData['error'] ?? 'Login failed'};
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      return {'error': 'Login error: $e'};
    }
  }

// Register a new user with name, email, and password
static Future<bool> register(String userName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        body: json.encode({
          'userName': userName,
          'email': email,
          'password': password
        }),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        debugPrint('✅ Registration successful: ${data['message']}');
        return true;
      } else {
        debugPrint('❌ Registration failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      return false;
    }
  }

  static Future<void> testAuth() async {
  debugPrint('🔐 Testing authentication...');
  
  // Test Registration
  bool registered = await register('Test User', 'test@example.com', 'password123');
  debugPrint(registered ? '✅ Registration successful' : '❌ Registration failed');
  

}

// Add this test
static Future<void> testBaseUrl() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/'));
    debugPrint('Base URL status: ${response.statusCode}');
    debugPrint('Base URL response: ${response.body}');
  } catch (e) {
    debugPrint('Base URL error: $e');
  }
}

//update user name
static Future<bool> updateUsername(String newUsername, int userId) async {
  try {
     debugPrint('🔄 Updating username: $newUsername for user: $userId');
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/username'),
      body: json.encode({
        'username': newUsername,
        'userId': userId  // ← Send user ID
      }),
      headers: {'Content-Type': 'application/json'},
    );

    debugPrint('📡 Status: ${response.statusCode}');
    debugPrint('📡 Body: ${response.body}');
    return response.statusCode == 200;
  } catch (e) {
    debugPrint('❌ Error: $e');
    return false;
  }
}

//update profile picture
static Future<bool> uploadProfilePicture(File imageFile, int userId) async {
  try {
    var request = http.MultipartRequest(
      'PUT', 
      Uri.parse('$baseUrl/api/users/profile-picture')
    );
    
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path)
    );
    
    // Add user ID to request
    request.fields['userId'] = userId.toString();
    
    var response = await request.send();
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

//Get profile picture
static Future<String?> getProfilePicture(int userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/profile-picture?userId=$userId')
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['imagePath']; // Returns the image path from database
    } else {
      print('❌ Failed to get profile picture: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ Error getting profile picture: $e');
    return null;
  }
}

// Get all recipes
static Future<List<Map<String, dynamic>>> getRecipes() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recipes'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['recipes'] ?? []);
    } else {
      print('❌ Failed to fetch recipes: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('❌ Error fetching recipes: $e');
    return [];
  }
}
  
// Upload recipe with image
static Future<bool> uploadRecipe(Map<String, dynamic> recipeData, File? imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/recipes'));
      
      // Add recipe data
      request.fields['name'] = recipeData['name'];
      request.fields['category'] = recipeData['category'];
      request.fields['time'] = recipeData['time'];
      request.fields['calories'] = recipeData['calories'];
      request.fields['ingredients'] = json.encode(recipeData['ingredients']);
      request.fields['instructions'] = json.encode(recipeData['instructions']);
      request.fields['userId'] = recipeData['userId'].toString();
      
      // Add image if exists
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path)
        );
      }
      
      var response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('❌ Error uploading recipe: $e');
      return false;
    }
  }
}