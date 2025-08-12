import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final String? errorTitle;
  final String? errorMessage;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorTitle,
    this.errorMessage,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;
  Object? error;
  StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 24),
              Text(
                widget.errorTitle ?? 'Something went wrong',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.errorMessage ??
                    'We encountered an unexpected error. Please try refreshing the page.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hasError = false;
                    error = null;
                    stackTrace = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 24),
                ExpansionTile(
                  title: Text(
                    'Error Details',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        error.toString(),
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void handleError(Object error, StackTrace stackTrace) {
    setState(() {
      hasError = true;
      this.error = error;
      this.stackTrace = stackTrace;
    });

    // Log error for debugging
    debugPrint('ErrorBoundary caught error: $error');
    debugPrint('StackTrace: $stackTrace');
  }
}

// Extension to wrap widgets with error boundary
extension ErrorBoundaryExtension on Widget {
  Widget withErrorBoundary({String? errorTitle, String? errorMessage}) {
    return ErrorBoundary(
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      child: this,
    );
  }
}
