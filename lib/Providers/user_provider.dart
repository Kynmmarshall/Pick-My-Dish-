import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pick_my_dish/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  int _userId = 0;
  String _profilePicture = 'assets/login/noPicture.png';
  List<Map<String, dynamic>> _userRecipes = [];
  List<int> _userFavorites = [];
  Map<String, dynamic> _userSettings = {};
  
  // Add these static keys for SharedPreferences
  static const String _userKey = 'user_data';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _profileImageKey = 'profile_image';
  static const String _isLoggedInKey = 'is_logged_in';

  User? get user => _user;
  String get profilePicture => _profilePicture;
  String get username => _user?.username ?? 'Guest';
  int get userId => _userId;
  String get email => _user?.email ?? '';
  String? get profileImage => _user?.profileImage;
  bool get isLoggedIn => _user != null;

  /// Initialize provider - load saved user data
  Future<void> init() async {
    await _loadUserData();
  }

  /// Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (isLoggedIn) {
        final savedUserId = prefs.getInt(_userIdKey) ?? 0;
        final savedUsername = prefs.getString(_usernameKey) ?? '';
        final savedEmail = prefs.getString(_emailKey) ?? '';
        final savedProfileImage = prefs.getString(_profileImageKey);
        
        if (savedUserId > 0 && savedUsername.isNotEmpty) {
          _userId = savedUserId;
          _user = User(
            id: savedUserId.toString(),
            username: savedUsername,
            email: savedEmail,
            profileImage: savedProfileImage,
          );
          
          if (savedProfileImage != null && savedProfileImage.isNotEmpty) {
            _profilePicture = savedProfileImage;
          }
          
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_user != null) {
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setInt(_userIdKey, _userId);
        await prefs.setString(_usernameKey, _user!.username);
        await prefs.setString(_emailKey, _user!.email);
        
        if (_user!.profileImage != null) {
          await prefs.setString(_profileImageKey, _user!.profileImage!);
        }
      } else {
        await prefs.setBool(_isLoggedInKey, false);
        await prefs.remove(_userIdKey);
        await prefs.remove(_usernameKey);
        await prefs.remove(_emailKey);
        await prefs.remove(_profileImageKey);
      }
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  /// Set user from API response and save to storage
  void setUser(User user) {
    _user = user;
    
    // Try to extract userId from user object
    try {
      _userId = int.tryParse(user.id) ?? 0;
    } catch (e) {
      _userId = 0;
    }
    
    _saveUserData();
    notifyListeners();
  }

  void setUserFromJson(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);
    
    try {
      _userId = int.tryParse(_user!.id) ?? 0;
    } catch (e) {
      _userId = 0;
    }
    
    _saveUserData();
    notifyListeners();
  }

  void updateUsername(String newUsername, int userId) {
    if (_user != null) {
      _user = _user!.copyWith(username: newUsername);
      _saveUserData();
      notifyListeners();
    }
  }

  void updateProfilePicture(String imagePath) {
    _profilePicture = imagePath;
    if (_user != null) {
      _user = _user!.copyWith(profileImage: imagePath);
      _saveUserData();
    }
    notifyListeners();
  }

  void setUserId(int userId) {
    _userId = userId;
    _saveUserData();
    notifyListeners();
  }

  /// Clear ALL user data including SharedPreferences
  Future<void> clearAllUserData() async {
    _user = null;
    _userId = 0;
    _profilePicture = 'assets/login/noPicture.png';
    _userRecipes = [];
    _userFavorites = [];
    _userSettings = {};

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear ALL shared preferences
    } catch (e) {
      debugPrint('Error clearing shared preferences: $e');
    }

    // Clear image cache
    await _clearImageCache();

    notifyListeners();
  }

  Future<void> _clearImageCache() async {
    try {
      final cacheManager = DefaultCacheManager();
      await cacheManager.emptyCache();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  /// Logout - clear everything
  Future<void> logout() async {
    await clearAllUserData();
    debugPrint('✅ User logged out - all data cleared');
  }
}
