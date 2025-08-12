import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, DateTime> _startTimes = {};
  final Map<String, List<Duration>> _measurements = {};
  final List<String> _errors = [];

  // Start timing an operation
  void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
  }

  // End timing an operation
  void endTimer(String operation) {
    final startTime = _startTimes[operation];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _measurements.putIfAbsent(operation, () => []).add(duration);
      _startTimes.remove(operation);
      
      if (kDebugMode) {
        print('Performance: $operation took ${duration.inMilliseconds}ms');
      }
    }
  }

  // Log an error
  void logError(String error, [StackTrace? stackTrace]) {
    _errors.add('${DateTime.now()}: $error');
    if (kDebugMode) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }

  // Get average duration for an operation
  Duration? getAverageDuration(String operation) {
    final measurements = _measurements[operation];
    if (measurements == null || measurements.isEmpty) return null;
    
    final totalMs = measurements.fold<int>(
      0, 
      (sum, duration) => sum + duration.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ measurements.length);
  }

  // Get performance report
  Map<String, dynamic> getPerformanceReport() {
    final report = <String, dynamic>{};
    
    for (final operation in _measurements.keys) {
      final measurements = _measurements[operation]!;
      final avgDuration = getAverageDuration(operation);
      
      report[operation] = {
        'count': measurements.length,
        'average_ms': avgDuration?.inMilliseconds ?? 0,
        'min_ms': measurements.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b),
        'max_ms': measurements.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b),
      };
    }
    
    report['errors'] = _errors;
    return report;
  }

  // Clear all measurements
  void clear() {
    _startTimes.clear();
    _measurements.clear();
    _errors.clear();
  }

  // Widget wrapper for performance monitoring
  static Widget monitor({
    required Widget child,
    required String operation,
  }) {
    return _PerformanceMonitorWidget(
      operation: operation,
      child: child,
    );
  }
}

class _PerformanceMonitorWidget extends StatefulWidget {
  final String operation;
  final Widget child;

  const _PerformanceMonitorWidget({
    required this.operation,
    required this.child,
  });

  @override
  State<_PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<_PerformanceMonitorWidget> {
  @override
  void initState() {
    super.initState();
    PerformanceMonitor().startTimer(widget.operation);
  }

  @override
  void dispose() {
    PerformanceMonitor().endTimer(widget.operation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Extension for easy widget wrapping
extension PerformanceMonitorExtension on Widget {
  Widget withPerformanceMonitor(String operation) {
    return PerformanceMonitor.monitor(
      operation: operation,
      child: this,
    );
  }
}

// Performance-aware ListView builder
class PerformantListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const PerformantListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

// Performance-aware GridView builder
class PerformantGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const PerformantGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}