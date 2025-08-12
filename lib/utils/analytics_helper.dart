import 'package:flutter/foundation.dart';

class AnalyticsHelper {
  static final AnalyticsHelper _instance = AnalyticsHelper._internal();
  factory AnalyticsHelper() => _instance;
  AnalyticsHelper._internal();

  final Map<String, int> _eventCounts = {};
  final Map<String, DateTime> _sessionData = {};
  final List<Map<String, dynamic>> _userActions = [];

  // Track user events
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    _eventCounts[eventName] = (_eventCounts[eventName] ?? 0) + 1;
    
    final eventData = {
      'event': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      'parameters': parameters ?? {},
    };
    
    _userActions.add(eventData);
    
    if (kDebugMode) {
      print('Analytics Event: $eventName ${parameters != null ? 'with $parameters' : ''}');
    }
  }

  // Track screen views
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    trackEvent('screen_view', parameters: {
      'screen_name': screenName,
      ...?parameters,
    });
  }

  // Track user interactions
  void trackUserInteraction(String action, String element, {Map<String, dynamic>? parameters}) {
    trackEvent('user_interaction', parameters: {
      'action': action,
      'element': element,
      ...?parameters,
    });
  }

  // Track performance metrics
  void trackPerformance(String metric, double value, {String? unit}) {
    trackEvent('performance_metric', parameters: {
      'metric': metric,
      'value': value,
      'unit': unit ?? 'ms',
    });
  }

  // Track errors
  void trackError(String error, {String? stackTrace, Map<String, dynamic>? context}) {
    trackEvent('error', parameters: {
      'error_message': error,
      'stack_trace': stackTrace,
      'context': context ?? {},
    });
  }

  // Track conversion events
  void trackConversion(String conversionType, {Map<String, dynamic>? parameters}) {
    trackEvent('conversion', parameters: {
      'conversion_type': conversionType,
      ...?parameters,
    });
  }

  // Session management
  void startSession() {
    _sessionData['session_start'] = DateTime.now();
    trackEvent('session_start');
  }

  void endSession() {
    final startTime = _sessionData['session_start'];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      trackEvent('session_end', parameters: {
        'session_duration_seconds': duration.inSeconds,
      });
    }
  }

  // Get analytics summary
  Map<String, dynamic> getAnalyticsSummary() {
    final sessionStart = _sessionData['session_start'];
    final currentSessionDuration = sessionStart != null 
        ? DateTime.now().difference(sessionStart).inSeconds 
        : 0;

    return {
      'total_events': _userActions.length,
      'event_counts': Map<String, int>.from(_eventCounts),
      'current_session_duration_seconds': currentSessionDuration,
      'recent_actions': _userActions.take(10).toList(),
    };
  }

  // Export analytics data
  List<Map<String, dynamic>> exportAnalyticsData() {
    return List<Map<String, dynamic>>.from(_userActions);
  }

  // Clear analytics data
  void clearAnalyticsData() {
    _eventCounts.clear();
    _sessionData.clear();
    _userActions.clear();
  }

  // Predefined event tracking methods
  void trackButtonClick(String buttonName, {String? location}) {
    trackUserInteraction('click', 'button', parameters: {
      'button_name': buttonName,
      'location': location,
    });
  }

  void trackFormSubmission(String formName, {bool? success, String? errorMessage, Map<String, dynamic>? parameters}) {
    trackEvent('form_submission', parameters: {
      'form_name': formName,
      'success': success,
      'error_message': errorMessage,
      ...?parameters,
    });
  }

  void trackNavigation(String fromScreen, String toScreen) {
    trackEvent('navigation', parameters: {
      'from_screen': fromScreen,
      'to_screen': toScreen,
    });
  }

  void trackSearch(String query, {int? resultCount}) {
    trackEvent('search', parameters: {
      'query': query,
      'result_count': resultCount,
    });
  }

  void trackProjectView(String projectId, String projectTitle) {
    trackEvent('project_view', parameters: {
      'project_id': projectId,
      'project_title': projectTitle,
    });
  }

  void trackServiceInterest(String serviceName) {
    trackEvent('service_interest', parameters: {
      'service_name': serviceName,
    });
  }

  void trackContactFormSubmission({
    required String name,
    required String email,
    bool? success,
  }) {
    trackFormSubmission('contact_form', parameters: {
      'user_name': name,
      'user_email': email,
    });
  }

  void trackVideoPlay(String videoName, {double? duration}) {
    trackEvent('video_play', parameters: {
      'video_name': videoName,
      'duration': duration,
    });
  }

  void trackDownload(String fileName, String fileType) {
    trackEvent('download', parameters: {
      'file_name': fileName,
      'file_type': fileType,
    });
  }

  void trackSocialShare(String platform, String content) {
    trackEvent('social_share', parameters: {
      'platform': platform,
      'content': content,
    });
  }

  // A/B Testing support
  void trackExperiment(String experimentName, String variant) {
    trackEvent('experiment_view', parameters: {
      'experiment_name': experimentName,
      'variant': variant,
    });
  }

  // User engagement metrics
  void trackTimeOnPage(String pageName, Duration timeSpent) {
    trackEvent('time_on_page', parameters: {
      'page_name': pageName,
      'time_spent_seconds': timeSpent.inSeconds,
    });
  }

  void trackScrollDepth(String pageName, double scrollPercentage) {
    trackEvent('scroll_depth', parameters: {
      'page_name': pageName,
      'scroll_percentage': scrollPercentage,
    });
  }

  // Business metrics
  void trackLeadGeneration(String source, Map<String, dynamic> leadData) {
    trackConversion('lead_generation', parameters: {
      'source': source,
      'lead_data': leadData,
    });
  }

  void trackQuoteRequest(String serviceType, Map<String, dynamic> requestData) {
    trackConversion('quote_request', parameters: {
      'service_type': serviceType,
      'request_data': requestData,
    });
  }

  // Technical metrics
  void trackPageLoadTime(String pageName, Duration loadTime) {
    trackPerformance('page_load_time', loadTime.inMilliseconds.toDouble(), unit: 'ms');
  }

  void trackApiCall(String endpoint, Duration responseTime, {bool? success}) {
    trackPerformance('api_response_time', responseTime.inMilliseconds.toDouble(), unit: 'ms');
    trackEvent('api_call', parameters: {
      'endpoint': endpoint,
      'response_time_ms': responseTime.inMilliseconds,
      'success': success,
    });
  }
}