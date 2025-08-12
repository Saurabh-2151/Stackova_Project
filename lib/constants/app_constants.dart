import 'package:flutter/material.dart';

class AppConstants {
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration heroAnimation = Duration(milliseconds: 1500);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 20.0;

  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;

  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 32.0;
  static const double fontSizeDisplay = 48.0;

  // Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXL = 32.0;
  static const double iconSizeXXL = 48.0;

  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;

  // Container Constraints
  static const double maxContentWidth = 1200.0;
  static const double maxFormWidth = 600.0;
  static const double maxCardWidth = 400.0;

  // Grid Settings
  static const double gridSpacing = 16.0;
  static const double gridRunSpacing = 16.0;

  // Colors
  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color secondaryColor = Color(0xFF3B82F6);
  static const Color accentColor = Color(0xFF60A5FA);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color surfaceColor = Color(0xFFF8FAFC);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1E293B);
  static const Color textSecondaryColor = Color(0xFF64748B);
  static const Color textTertiaryColor = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surfaceColor, Color(0xFFE2E8F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static const List<BoxShadow> shadowS = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowM = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowL = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowXL = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 30,
      offset: Offset(0, 15),
    ),
  ];

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Performance Settings
  static const int maxProjectsPerPage = 50;
  static const int maxParticles = 8;
  static const Duration videoTimeout = Duration(seconds: 10);
  static const Duration debounceDelay = Duration(milliseconds: 300);

  // Accessibility
  static const double minTouchTarget = 44.0;
  static const double maxLineLength = 80.0;
  static const double minContrastRatio = 4.5;

  // Asset Paths
  static const String logoPath = 'assets/logo.png';
  static const String videoPath = 'assets/homeVedio.mp4';
  static const String assetsPath = 'assets/';

  // API Settings (for future use)
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}