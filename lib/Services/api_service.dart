import 'dart:convert';  // For JSON encoding/decoding
import 'package:http/http.dart' as http;  // For HTTP requests

class ApiService {
  // Backend server URL - using your VPS IP address and port 3000
  static const String baseUrl = 'http://38.242.246.126:3000';
  
  // Test if backend is reachable and database is connected
  static Future<void> testConnection() async {
    try {
      // Send GET request to test endpoint
      final response = await http.get(Uri.parse('$baseUrl/api/test-db'));
      print('Backend status: ${response.statusCode}');  // Should be 200 if successful
      print('Response: ${response.body}');  // Response data from backend
    } catch (e) {
      print('Connection error: $e');  // Handle network/database errors
    }
  }

  // Fetch all recipes from the backend
  static Future<List<dynamic>> getRecipes() async {
    // Send GET request to recipes endpoint
    final response = await http.get(Uri.parse('$baseUrl/api/recipes'));
    // Convert JSON response to Dart List
    return json.decode(response.body);
  }

  // Register a new user with name, email, and password
  static Future<bool> register(String fullName, String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/register'),
    body: json.encode({
      'fullName': fullName,
      'email': email, 
      'password': password
    }),
    headers: {'Content-Type': 'application/json'},
  );
  return response.statusCode == 201; // 201 for created
}

  // Authenticate user with email and password
  static Future<bool> login(String email, String password) async {
    // Send POST request to login endpoint
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      // Convert Dart Map to JSON string for request body
      body: json.encode({'email': email, 'password': password}),
      // Set content type to JSON
      headers: {'Content-Type': 'application/json'},
    );
    // Return true if login successful (status code 200)
    return response.statusCode == 200;
  }

  static Future<void> testAuth() async {
  print('🔐 Testing authentication...');
  
  // Test Registration
  bool registered = await register('Test User', 'test@example.com', 'password123');
  print(registered ? '✅ Registration successful' : '❌ Registration failed');
  
  // Test Login
  bool loggedIn = await login('test@example.com', 'password123');
  print(loggedIn ? '✅ Login successful' : '❌ Login failed');
}

}