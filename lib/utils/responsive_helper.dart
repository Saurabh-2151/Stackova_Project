import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../config/app_config.dart';

class ResponsiveHelper {
  // Breakpoint checks
  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }

  static bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }

  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }

  static bool is4K(BuildContext context) {
    return ResponsiveBreakpoints.of(context).equals('4K');
  }

  // Screen size utilities
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive values
  static double responsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    double? fourK,
  }) {
    if (is4K(context) && fourK != null) return fourK;
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  // Responsive padding
  static EdgeInsets responsivePadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
    double? fourK,
  }) {
    final value = responsiveValue(
      context,
      mobile: mobile ?? 16,
      tablet: tablet ?? 24,
      desktop: desktop ?? 32,
      fourK: fourK ?? 40,
    );
    return EdgeInsets.all(value);
  }

  // Responsive horizontal padding
  static EdgeInsets responsiveHorizontalPadding(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? desktop,
    double? fourK,
  }) {
    final value = responsiveValue(
      context,
      mobile: mobile ?? 20,
      tablet: tablet ?? 40,
      desktop: desktop ?? 80,
      fourK: fourK ?? 120,
    );
    return EdgeInsets.symmetric(horizontal: value);
  }

  // Responsive font size
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    double? fourK,
  }) {
    return responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      fourK: fourK,
    );
  }

  // Grid column count
  static int responsiveGridColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int fourK = 4,
  }) {
    if (is4K(context)) return fourK;
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  // Responsive spacing
  static double responsiveSpacing(
    BuildContext context, {
    double mobile = 16,
    double tablet = 20,
    double desktop = 24,
    double fourK = 32,
  }) {
    return responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      fourK: fourK,
    );
  }

  // Check if screen is small (mobile portrait)
  static bool isSmallScreen(BuildContext context) {
    return screenWidth(context) < AppConfig.mobileBreakpoint;
  }

  // Check if screen is medium (tablet)
  static bool isMediumScreen(BuildContext context) {
    final width = screenWidth(context);
    return width >= AppConfig.mobileBreakpoint && 
           width < AppConfig.tabletBreakpoint;
  }

  // Check if screen is large (desktop)
  static bool isLargeScreen(BuildContext context) {
    final width = screenWidth(context);
    return width >= AppConfig.tabletBreakpoint && 
           width < AppConfig.desktopBreakpoint;
  }

  // Check if screen is extra large (4K)
  static bool isExtraLargeScreen(BuildContext context) {
    return screenWidth(context) >= AppConfig.desktopBreakpoint;
  }
}