import 'package:flutter/material.dart';

class ImageHelper {
  // Optimized image widget with error handling and loading states
  static Widget optimizedImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableMemoryCache = true,
  }) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget(width, height);
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }

  // Network image with caching and optimization
  static Widget optimizedNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return placeholder ?? _buildDefaultPlaceholder(width, height);
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget(width, height);
      },
    );
  }

  // Lazy loading image widget
  static Widget lazyImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FutureBuilder<void>(
          future: _precacheImage(imagePath, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return optimizedImage(
                imagePath: imagePath,
                width: width,
                height: height,
                fit: fit,
                errorWidget: errorWidget,
              );
            }
            
            return placeholder ?? _buildDefaultPlaceholder(width, height);
          },
        );
      },
    );
  }

  // Precache image for better performance
  static Future<void> _precacheImage(String imagePath, BuildContext context) {
    return precacheImage(AssetImage(imagePath), context);
  }

  // Default placeholder widget
  static Widget _buildDefaultPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
        ),
      ),
    );
  }

  // Default error widget
  static Widget _buildDefaultErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 32,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Image not found',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Avatar with fallback
  static Widget avatar({
    String? imageUrl,
    String? name,
    double radius = 20,
    Color? backgroundColor,
    Color? textColor,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey[200],
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Handle image loading error
        },
        child: imageUrl.isEmpty ? _buildInitials(name, textColor) : null,
      );
    }
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? const Color(0xFF3B82F6),
      child: _buildInitials(name, textColor),
    );
  }

  // Build initials for avatar
  static Widget _buildInitials(String? name, Color? textColor) {
    final initials = _getInitials(name);
    return Text(
      initials,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Get initials from name
  static String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }

  // Responsive image sizing
  static double getResponsiveImageSize(BuildContext context, {
    double mobile = 100,
    double tablet = 150,
    double desktop = 200,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) return mobile;
    if (screenWidth < 1024) return tablet;
    return desktop;
  }
}