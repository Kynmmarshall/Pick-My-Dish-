import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedProfileImage extends StatelessWidget {
  final String imagePath;
  final double radius;
  final bool isProfilePicture;

  const CachedProfileImage({
    Key? key,
    required this.imagePath,
    this.radius = 60,
    this.isProfilePicture = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if it's a server image
    if (imagePath.startsWith('uploads/')) {
      final url = 'http://38.242.246.126:3000/$imagePath';
      
      return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => _buildImage(imageProvider),
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
        cacheKey: imagePath, // Use path as cache key
        maxWidthDiskCache: 400, // Cache smaller version
        maxHeightDiskCache: 400,
      );
    } else {
      // Local asset
      return _buildImage(AssetImage(imagePath));
    }
  }

  Widget _buildImage(ImageProvider imageProvider) {
    if (isProfilePicture) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Widget _buildPlaceholder() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[800],
      child: CircularProgressIndicator(color: Colors.orange),
    );
  }

  Widget _buildErrorWidget() {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage('assets/login/noPicture.png'),
    );
  }
}