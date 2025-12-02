import 'package:flutter/material.dart';
import 'package:pick_my_dish/Services/image_cache_service.dart';

class ImageUtils {
  // Simple profile image widget
  static Widget profileImage(String imagePath, double radius) {
    if (imagePath.startsWith('uploads/') || imagePath.contains('profile-')) {
      final url = 'http://38.242.246.126:3000/$imagePath';
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(url),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(imagePath),
    );
  }
  
  // Simple async caching during login
  static Future<void> cacheProfileImage(String imagePath) async {
    if (imagePath.startsWith('uploads/') || imagePath.contains('profile-')) {
      final url = 'http://38.242.246.126:3000/$imagePath';
      await ImageCacheService.cacheImage(url);
    }
  }
}