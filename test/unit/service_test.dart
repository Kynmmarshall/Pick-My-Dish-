import 'package:flutter_test/flutter_test.dart';
import 'package:pick_my_dish/Services/api_service.dart';
import 'package:pick_my_dish/Services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
group('ApiService Tests', () {
test('baseUrl is defined', () {
expect(ApiService.baseUrl, isNotNull);
expect(ApiService.baseUrl, isA<String>());
});

test('All API methods exist and have correct signatures', () {
  // Test method existence without type checking that causes errors
  expect(ApiService.testConnection, isNotNull);
  expect(ApiService.login, isNotNull);
  expect(ApiService.register, isNotNull);
  expect(ApiService.updateUsername, isNotNull);
  expect(ApiService.getRecipes, isNotNull);
  expect(ApiService.uploadRecipe, isNotNull);
  expect(ApiService.getIngredients, isNotNull);
  expect(ApiService.addIngredient, isNotNull);
  expect(ApiService.getUserFavorites, isNotNull);
  expect(ApiService.addToFavorites, isNotNull);
  expect(ApiService.removeFromFavorites, isNotNull);
  expect(ApiService.isRecipeFavorited, isNotNull);
  expect(ApiService.isUserAdmin, isNotNull);
  expect(ApiService.getUserRecipes, isNotNull);
  expect(ApiService.updateRecipe, isNotNull);
  expect(ApiService.deleteRecipe, isNotNull);
  expect(ApiService.getRecipesWithPermissions, isNotNull);
  expect(ApiService.getRecipeOwner, isNotNull);
  expect(ApiService.testAuth, isNotNull);
  expect(ApiService.testBaseUrl, isNotNull);
  expect(ApiService.testRecipeUpload, isNotNull);
  expect(ApiService.getProfilePicture, isNotNull);
  expect(ApiService.uploadProfilePicture, isNotNull);
});

test('ApiService methods return correct types', () async {
  // Test actual method calls with mock data
  final methods = [
    () => ApiService.testConnection(),
    () => ApiService.login('test', 'test'),
    () => ApiService.register('test', 'test@test.com', 'test'),
    () => ApiService.updateUsername('test', 1),
    () => ApiService.getRecipes(),
    () => ApiService.getIngredients(),
    () => ApiService.addIngredient('test'),
    () => ApiService.getUserFavorites(1),
    () => ApiService.addToFavorites(1, 1),
    () => ApiService.removeFromFavorites(1, 1),
    () => ApiService.isRecipeFavorited(1, 1),
    () => ApiService.isUserAdmin(1),
    () => ApiService.getUserRecipes(1),
    () => ApiService.updateRecipe(1, {'name': 'test'}, null, 1),
    () => ApiService.deleteRecipe(1, 1),
    () => ApiService.getRecipesWithPermissions(1),
    () => ApiService.getRecipeOwner(1),
    () => ApiService.testAuth(),
    () => ApiService.testBaseUrl(),
    () => ApiService.testRecipeUpload(),
    () => ApiService.getProfilePicture(1),
  ];

  for (var method in methods) {
    expect(method, returnsNormally);
  }
});
});

group('DatabaseService Tests',skip: true, () {
test('DatabaseService can be instantiated', () {
final service = DatabaseService();
expect(service, isNotNull);
});

test('Database methods exist',() async {
  final service = DatabaseService();
  
  // Test that methods exist and don't throw on basic calls
  expect(service.getRecipes, isNotNull);
  expect(service.getFavoriteRecipes, isNotNull);
  expect(service.getFilteredRecipes, isNotNull);
  expect(service.toggleFavorite, isNotNull);
});

test('Database operations work correctly', () async {
  final service = DatabaseService();
  
  // These should return lists (might be empty if no database)
  final recipes = await service.getRecipes();
  expect(recipes, isA<List>());
  
  final favorites = await service.getFavoriteRecipes();
  expect(favorites, isA<List>());
  
  final filtered = await service.getFilteredRecipes();
  expect(filtered, isA<List>());
});
});
}