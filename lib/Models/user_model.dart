class User {
  final String username;
  final String email;
  final String? profileImage;

  User({
    required this.username,
    required this.email,
    this.profileImage,
  });

  User copyWith({
    String? username,
    String? email,
    String? profileImage,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}