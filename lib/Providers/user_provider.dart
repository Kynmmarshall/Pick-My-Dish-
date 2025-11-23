import 'package:flutter/material.dart';
import 'package:pick_my_dish/Models/user_model.dart';

/// Provider that holds and manages the current authenticated user.
/// 
/// Uses [ChangeNotifier] so widgets can listen to changes and rebuild
/// when the user data is updated or cleared.
class UserProvider with ChangeNotifier {
  // Backing field for the current user. Null when no user is logged in.
  User? _user;

  /// Returns the current user, or null if not signed in.
  User? get user => _user;

  /// Returns the username of the current user, or a default 'User' string
  /// when no user is available.
  String get username => _user?.username ?? 'User';

  /// Indicates whether a user is currently logged in.
  bool get isLoggedIn => _user != null;

  /// Set (or replace) the current user and notify listeners.
  ///
  /// Call this after a successful login or when user data is fetched.
  void setUser(User user) {
    _user = user;
    notifyListeners(); // Notify widgets that depend on user data.
  }

  /// Update only the username for the current user and notify listeners.
  ///
  /// If there is no current user, this method does nothing.
  void updateUsername(String newUsername) {
    if (_user != null) {
      // Use the model's copyWith to preserve other fields.
      _user = _user!.copyWith(username: newUsername);
      notifyListeners();
    }
  }

  /// Clear the current user (log out) and notify listeners.
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}