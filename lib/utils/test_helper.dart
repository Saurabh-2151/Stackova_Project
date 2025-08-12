import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TestHelper {
  // Test data for development
  static const List<String> sampleTechnologies = [
    'Flutter',
    'React',
    'Node.js',
    'Python',
    'Firebase',
    'MongoDB',
    'PostgreSQL',
    'AWS',
    'Docker',
    'Kubernetes',
  ];

  static const List<String> sampleProjectTitles = [
    'E-commerce Platform',
    'Task Management App',
    'Social Media Dashboard',
    'Learning Management System',
    'Healthcare Portal',
    'Financial Analytics Tool',
    'Real Estate Platform',
    'Food Delivery App',
    'Travel Booking System',
    'Inventory Management',
  ];

  static const List<String> sampleDescriptions = [
    'A comprehensive solution for modern businesses',
    'Streamlined workflow management for teams',
    'Advanced analytics and reporting capabilities',
    'User-friendly interface with powerful features',
    'Scalable architecture for enterprise needs',
    'Mobile-first design with responsive layout',
    'Real-time data synchronization and updates',
    'Secure authentication and authorization',
    'Integration with third-party services',
    'Optimized performance and user experience',
  ];

  // Generate test data
  static Map<String, dynamic> generateTestProject({
    String? id,
    String? title,
    String? description,
    List<String>? technologies,
    String? category,
  }) {
    final random = DateTime.now().millisecondsSinceEpoch;
    
    return {
      'id': id ?? 'test_project_$random',
      'title': title ?? sampleProjectTitles[random % sampleProjectTitles.length],
      'description': description ?? sampleDescriptions[random % sampleDescriptions.length],
      'technologies': technologies ?? _getRandomTechnologies(),
      'category': category ?? _getRandomCategory(),
      'duration': '${2 + (random % 6)} months',
      'teamSize': '${3 + (random % 5)} developers',
      'features': _generateFeatures(),
    };
  }

  static List<String> _getRandomTechnologies() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final count = 3 + (random % 3); // 3-5 technologies
    final shuffled = List<String>.from(sampleTechnologies)..shuffle();
    return shuffled.take(count).toList();
  }

  static String _getRandomCategory() {
    final categories = ['Web App', 'Android App', 'iOS App'];
    final random = DateTime.now().millisecondsSinceEpoch;
    return categories[random % categories.length];
  }

  static List<String> _generateFeatures() {
    final features = [
      'Modern responsive design',
      'Real-time data synchronization',
      'Advanced security features',
      'Scalable architecture',
      'User-friendly interface',
      'Analytics and reporting',
      'Mobile-responsive design',
      'Cloud integration',
    ];
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final count = 4 + (random % 4); // 4-7 features
    final shuffled = List<String>.from(features)..shuffle();
    return shuffled.take(count).toList();
  }

  // Performance testing utilities
  static void measureWidgetBuildTime(
    String widgetName,
    Widget Function() builder,
  ) {
    if (!kDebugMode) return;
    
    final stopwatch = Stopwatch()..start();
    builder();
    stopwatch.stop();
    
    print('Widget Build Time - $widgetName: ${stopwatch.elapsedMilliseconds}ms');
  }

  // Memory usage monitoring
  static void logMemoryUsage(String operation) {
    if (!kDebugMode) return;
    
    // This is a simplified version - in production you'd use more sophisticated tools
    print('Memory check after $operation - ${DateTime.now()}');
  }

  // Accessibility testing helpers
  static bool hasSemanticLabel(Widget widget) {
    // This would need to be implemented with proper widget testing
    // For now, it's a placeholder for the concept
    return widget is Semantics && widget.properties.label != null;
  }

  // Responsive testing utilities
  static void testResponsiveBreakpoints(BuildContext context) {
    if (!kDebugMode) return;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    print('Screen dimensions: ${screenWidth}x$screenHeight');
    
    if (screenWidth < 600) {
      print('Device type: Mobile');
    } else if (screenWidth < 1024) {
      print('Device type: Tablet');
    } else {
      print('Device type: Desktop');
    }
  }

  // Network simulation for testing
  static Future<T> simulateNetworkDelay<T>(
    Future<T> future, {
    Duration delay = const Duration(seconds: 1),
  }) async {
    if (kDebugMode) {
      await Future.delayed(delay);
    }
    return future;
  }

  // Error simulation for testing
  static Future<T> simulateRandomError<T>(
    Future<T> future, {
    double errorRate = 0.1, // 10% error rate
  }) async {
    if (kDebugMode) {
      final random = DateTime.now().millisecondsSinceEpoch % 100;
      if (random < (errorRate * 100)) {
        throw Exception('Simulated network error for testing');
      }
    }
    return future;
  }

  // Widget testing utilities
  static Widget wrapWithMaterialApp(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }

  static Widget wrapWithMediaQuery(
    Widget widget, {
    double width = 375,
    double height = 812,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: Size(width, height),
        devicePixelRatio: 2.0,
      ),
      child: widget,
    );
  }

  // Debug utilities
  static void debugPrintWidgetTree(BuildContext context) {
    if (kDebugMode) {
      debugDumpApp();
    }
  }

  static void debugPrintRenderTree(BuildContext context) {
    if (kDebugMode) {
      debugDumpRenderTree();
    }
  }

  // Performance benchmarking
  static Future<Duration> benchmarkOperation(
    String operationName,
    Future<void> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();
    
    final duration = stopwatch.elapsed;
    if (kDebugMode) {
      print('Benchmark - $operationName: ${duration.inMilliseconds}ms');
    }
    
    return duration;
  }

  // Color contrast testing
  static double calculateContrastRatio(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    
    final lighter = fgLuminance > bgLuminance ? fgLuminance : bgLuminance;
    final darker = fgLuminance > bgLuminance ? bgLuminance : fgLuminance;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  static bool meetsWCAGAAStandard(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 4.5;
  }

  static bool meetsWCAGAAAStandard(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 7.0;
  }
}