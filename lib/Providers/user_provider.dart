import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pick_my_dish/Models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  int _userId = 0;
  DateTime _joined = DateTime.now();
  /// Returns the current user, or null if not signed in.
  User? get user => _user;
  String _profilePicture = 'assets/login/noPicture.png';
  String get profilePicture => _profilePicture;
  /// Returns the username of the current user, or a default 'User' string
  /// when no user is available.
  String get username => _user?.username ?? 'Guest';  
  int get userId => _userId;  

  // Add these for complete cleanup
  List<Map<String, dynamic>> _userRecipes = [];
  List<int> _userFavorites = [];
  Map<String, dynamic> _userSettings = {};

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if token exists
      final savedToken = prefs.getString('auth_token');
      final savedUserId = prefs.getInt('user_id');
      final savedUsername = prefs.getString('username');
      final savedEmail = prefs.getString('email');
      final savedProfileImage = prefs.getString('profile_image');
      
      if (savedToken != null && savedUserId != null) {
        // Set token and user data
        _authToken = savedToken;
        _userId = savedUserId;
        
        // Create a user object from saved data
        if (savedUsername != null && savedEmail != null) {
          _user = User(
            id: savedUserId.toString(),
            username: savedUsername,
            email: savedEmail,
            profileImage: savedProfileImage,
          );
        }
        
        if (savedProfileImage != null && savedProfileImage.isNotEmpty) {
          _profilePicture = savedProfileImage;
        }
        
        debugPrint('✅ Loaded saved authentication for user: $savedUsername');
      } else {
        debugPrint('ℹ️ No saved authentication found');
      }
    } catch (e) {
      debugPrint('❌ Error loading saved auth: $e');
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  // Save authentication data to persistent storage
  Future<void> _saveAuthData(Map<String, dynamic> authData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (authData['token'] != null) {
        await prefs.setString('auth_token', authData['token']);
        _authToken = authData['token'];
      }
      
      if (authData['userId'] != null) {
        await prefs.setInt('user_id', authData['userId']);
        _userId = authData['userId'];
      }
      
      if (_user != null) {
        await prefs.setString('username', _user!.username);
        await prefs.setString('email', _user!.email);
        
        if (_user!.profileImage != null) {
          await prefs.setString('profile_image', _user!.profileImage!);
        }
      }
      
      debugPrint('💾 Authentication data saved');
    } catch (e) {
      debugPrint('❌ Error saving auth data: $e');
    }
  }

  // Clear saved authentication from persistent storage
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('profile_image');
      debugPrint('🗑️ Authentication data cleared from storage');
    } catch (e) {
      debugPrint('❌ Error clearing auth data: $e');
    }
  }

  
  /// Set (or replace) the current user and notify listeners.
  void setUser(User user, {Map<String, dynamic>? authData}) {
    _user = user;
    
    if (authData != null) {
      // Save authentication data to persistent storage
      _saveAuthData(authData);
    }
    
    notifyListeners();
  }

  /// Create and set user from JSON data with authentication data.
  void setUserFromJson(Map<String, dynamic> userData, {Map<String, dynamic>? authData}) {
    _user = User.fromJson(userData);
    
    if (authData != null) {
      // Save authentication data to persistent storage
      _saveAuthData(authData);
    }
    
    notifyListeners();
  }

  /// Update only the username for the current user and notify listeners.
  void updateUsername(String newUsername, int userId) {
    if (_user != null) {
      _user = _user!.copyWith(username: newUsername);
      // Update in storage
      _saveUsername(newUsername);
      notifyListeners();
    }
  }


  /// Update the user's profile image and notify listeners.
  ///
  /// If there is no current user, this method does nothing.
  void updateProfilePicture(String imagePath) {
    _profilePicture = imagePath;
    notifyListeners();
  }

  /// Save profile picture to persistent storage
  Future<void> _saveProfilePicture(String imagePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', imagePath);
    } catch (e) {
      debugPrint('❌ Error saving profile picture: $e');
    }
  }

  /// Clear the current user (log out) and notify listeners.
  void clearUser() {
    _user = null;
    _authToken = null;
    _userId = 0;
    _profilePicture = 'assets/login/noPicture.png';
    _userRecipes = [];
    _userFavorites = [];
    _userSettings = {};
    
    // Clear from persistent storage
    _clearAuthData();
    // Clear image cache
    _clearImageCache();
    
    notifyListeners();
  }

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  /// Debug method to print current user state
  void printUserState() {
    if (_user == null) {
      debugPrint('UserProvider: No user logged in');
    } else {
      debugPrint('UserProvider: Current user - ${_user!.toString()}');
      debugPrint('UserProvider: First name - $username');
    }
  }
  
  
  /// Clear ALL user data
  void clearAllUserData() {
    _user = null;
    _userId = 0;
    _profilePicture = 'assets/login/noPicture.png';
    _userRecipes = [];
    _userFavorites = [];
    _userSettings = {};
    
    // Clear image cache
    _clearImageCache();
    
    // Clear local storage (optional)
    _clearLocalStorage();
    
    notifyListeners();
  }

  Future<void> _clearImageCache() async {
    try {
      final cacheManager = DefaultCacheManager();
      
      // Clear ALL cached images (more thorough)
      await cacheManager.emptyCache();
      
      // OR clear only specific profile picture URLs
      // if you want more targeted clearing:
      if (_profilePicture.startsWith('http')) {
        await cacheManager.removeFile(_profilePicture);
      }
      
      debugPrint('🗑️ Image cache cleared');
    } catch (e) {
      debugPrint('⚠️ Error clearing cache: $e');
    }
  }

  Future<void> _clearLocalStorage() async {
    // Implement local storage clearing if using packages like SharedPreferences
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
  }

  /// Logout - clear everything
  void logout() {
    clearAllUserData();
    debugPrint('✅ User logged out - all data cleared');
  }
}
