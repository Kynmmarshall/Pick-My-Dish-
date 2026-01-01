// Import Dart library for JSON encoding/decoding support
import 'dart:convert';

/// User model class
/// Represents an authenticated user in the application
class User {
  // Unique identifier of the user
  final String id;

  // Username chosen by the user
  final String username;

  // Email address of the user
  final String email;

  // Optional profile image path or URL
  final String? profileImage;

  // Date the user joined the platform
  final DateTime joinedDate;

  // Indicates whether the user has administrator privileges
  final bool isAdmin;

  /// Constructor for creating a User object
  /// If joinedDate is not provided, the current date is used
  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.isAdmin = false,
    DateTime? joinedDate,
  }) : joinedDate = joinedDate ?? DateTime.now();

  /// Creates a new User object by copying the current one
  /// Allows selective updates while preserving immutability
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImage,
    DateTime? joinedDate,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      joinedDate: joinedDate ?? this.joinedDate,
      isAdmin: isAdmin, // Preserve admin status
    );
  }

  /// Factory constructor to create a User object from JSON data
  /// Handles API and database responses safely
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Ensure ID is always treated as a String
      id: json['id']?.toString() ?? '',

      // Parse basic user information
      username: json['username'] ?? '',
      email: json['email'] ?? '',

      // Profile image may come under different keys
      profileImage:
          json['profile_image_path'] ?? json['profileImage'],

      // Parse join date from database timestamp
      joinedDate: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,

      // Convert admin flag from integer to boolean
      isAdmin: (json['is_admin'] ?? 0) == 1,
    );
  }

  /// Converts a User object into JSON format
  /// Used when sending data to the backend API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_image_path': profileImage,
      'created_at': joinedDate.toIso8601String(),
    };
  }

  /// Provides a readable string representation of the User
  /// Useful for debugging and logging
  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, '
        'profileImage: $profileImage, joinedDate: $joinedDate)';
  }

  /// Overrides equality operator to compare User objects by value
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.joinedDate == joinedDate;
  }

  /// Generates a hash code for the User object
  /// Required when overriding the equality operator
  @override
  int get hashCode {
    return Object.hash(
      id,
      username,
      email,
      profileImage,
      joinedDate,
    );
  }
}

