import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();
  
  // Simple cache method
  static Future<File?> cacheImage(String url) async {
    try {
      return await _cacheManager.getSingleFile(url);
    } catch (e) {
      print('Cache error: $e');
      return null;
    }
  }
  
  // Get cached file
  static Future<FileResponse?> getCachedFile(String url) async {
    try {
      final file = await _cacheManager.getFileStream(url).first;
      return file;
    } catch (e) {
      return null;
    }
  }
  
  // Clear cache
  static Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}