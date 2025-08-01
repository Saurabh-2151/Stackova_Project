import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:video_player/video_player.dart';

/// Hero section widget with video background
///
/// Features:
/// - Video background with autoplay, loop, and mute
/// - Responsive video scaling that covers full background
/// - Fallback gradient background for loading/error states
/// - Optimized for web performance with proper error handling
/// - Text overlay with proper contrast for readability
/// - Smooth animations and floating particles
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Video controller and state
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize video controller
    _initializeVideo();

    // Start animations
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/homeVedio.mp4');

      // Add listener for video player state changes
      _videoController!.addListener(_onVideoPlayerStateChanged);

      await _videoController!.initialize();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _hasVideoError = false;
        });

        // Configure video settings for web optimization
        _videoController!.setLooping(true);
        _videoController!.setVolume(0.0); // Muted by default for autoplay compliance

        // Start playing with a small delay to ensure proper initialization
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _videoController != null) {
            _videoController!.play();
          }
        });
      }
    } catch (error) {
      debugPrint('Video initialization error: $error');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
          _hasVideoError = true;
        });
      }
    }
  }

  void _onVideoPlayerStateChanged() {
    if (_videoController != null && mounted) {
      // Handle video player errors
      if (_videoController!.value.hasError) {
        debugPrint('Video player error: ${_videoController!.value.errorDescription}');
        setState(() {
          _hasVideoError = true;
          _isVideoInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoPlayerStateChanged);
    _videoController?.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          // Video background
          if (_isVideoInitialized && _videoController != null)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),

          // Fallback gradient background (shown when video is loading or failed)
          if (!_isVideoInitialized || _hasVideoError)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F172A),
                      Color(0xFF1E293B),
                      Color(0xFF334155),
                    ],
                  ),
                ),
                child: !_hasVideoError && !_isVideoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : null,
              ),
            ),

          // Dark overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Optimized animated background particles (reduced count for better performance)
          ...List.generate(8, (index) => _buildFloatingParticle(index)),
          
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Company name with fade animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        'STACKOVA',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 48 : (isTablet ? 64 : 80),
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Animated subtitle
                  SizedBox(
                    height: isMobile ? 60 : 80,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Professional Web Development',
                          textStyle: GoogleFonts.inter(
                            fontSize: isMobile ? 18 : (isTablet ? 22 : 28),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF60A5FA),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Expert Mobile App Development',
                          textStyle: GoogleFonts.inter(
                            fontSize: isMobile ? 18 : (isTablet ? 22 : 28),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF60A5FA),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Custom Software Solutions',
                          textStyle: GoogleFonts.inter(
                            fontSize: isMobile ? 18 : (isTablet ? 22 : 28),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF60A5FA),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      totalRepeatCount: 3,
                      pause: const Duration(milliseconds: 2000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Description
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 600,
                      ),
                      child: Text(
                        'We create cutting-edge digital solutions that transform your business. From responsive web applications to native mobile apps, we deliver excellence in every project.',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // CTA Buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildCTAButton(
                          'Get Started',
                          true,
                          () {
                            // Scroll to contact section
                          },
                        ),
                        _buildCTAButton(
                          'View Portfolio',
                          false,
                          () {
                            // Scroll to portfolio section
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 3000 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Positioned(
          left: (index * 50.0) % MediaQuery.of(context).size.width,
          top: (index * 80.0) % MediaQuery.of(context).size.height,
          child: Transform.translate(
            offset: Offset(0, -value * 100),
            child: Opacity(
              opacity: (1 - value) * 0.3,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTAButton(String text, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                )
              : null,
          border: isPrimary
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
