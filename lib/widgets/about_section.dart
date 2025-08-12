import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/visibility/visibility_bloc.dart';
import '../bloc/visibility/visibility_event.dart';
import '../bloc/visibility/visibility_state.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  static const String sectionId = 'about';

  final List<StatItem> stats = [
    StatItem(number: '50+', label: 'Projects Completed'),
    StatItem(number: '30+', label: 'Happy Clients'),
    StatItem(number: '5+', label: 'Years Experience'),
    StatItem(number: '24/7', label: 'Support Available'),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the section in visibility BLoC
    final visibilityBloc = context.read<VisibilityBloc>();
    visibilityBloc.add(const InitializeSection(sectionId));
    visibilityBloc.initializeAnimationController(
      sectionId,
      this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3) {
      context.read<VisibilityBloc>().add(
        const SectionVisibilityChanged(
          sectionId: sectionId,
          isVisible: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return BlocBuilder<VisibilityBloc, VisibilityState>(
      builder: (context, state) {
        final visibilityBloc = context.read<VisibilityBloc>();
        final animationController = visibilityBloc.getAnimationController(sectionId);

        return VisibilityDetector(
          key: const Key('about-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 100,
        ),
        color: Colors.white,
        child: Column(
          children: [
            if (isMobile || isTablet) ...[
              // Mobile/Tablet Layout
              _buildContent(isMobile, isTablet, animationController),
              const SizedBox(height: 50),
              _buildStatsGrid(isMobile, isTablet, animationController),
            ] else ...[
              // Desktop Layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildContent(isMobile, isTablet, animationController),
                  ),
                  const SizedBox(width: 80),
                  Expanded(
                    flex: 1,
                    child: _buildStatsGrid(isMobile, isTablet, animationController),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet, AnimationController? animationController) {
    if (animationController == null) {
      return _buildContentStatic(isMobile, isTablet);
    }

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Column(
              crossAxisAlignment: isMobile || isTablet 
                  ? CrossAxisAlignment.center 
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  'About Stackova',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                  textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Transforming Ideas into Digital Reality',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 20 : (isTablet ? 24 : 28),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                  textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'At Stackova, we are passionate about creating innovative digital solutions that drive business growth. Our team of experienced developers and designers work collaboratively to deliver exceptional web and mobile applications.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.7,
                  ),
                  textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'We believe in the power of technology to transform businesses and create meaningful user experiences. From concept to deployment, we ensure every project meets the highest standards of quality and performance.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.7,
                  ),
                  textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
                ),
                
                const SizedBox(height: 32),
                
                // Key Points
                Column(
                  crossAxisAlignment: isMobile || isTablet 
                      ? CrossAxisAlignment.center 
                      : CrossAxisAlignment.start,
                  children: [
                    _buildKeyPoint('Expert Development Team'),
                    _buildKeyPoint('Cutting-edge Technologies'),
                    _buildKeyPoint('Agile Development Process'),
                    _buildKeyPoint('24/7 Support & Maintenance'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentStatic(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: isMobile || isTablet
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'About Stackova',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E293B),
          ),
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 24),

        Text(
          'Transforming Ideas into Digital Reality',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 20 : (isTablet ? 24 : 28),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3B82F6),
          ),
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 24),

        Text(
          'At Stackova, we are passionate about creating innovative digital solutions that drive business growth. Our team of experienced developers and designers work collaboratively to deliver exceptional web and mobile applications.',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            height: 1.7,
          ),
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 20),

        Text(
          'We believe in the power of technology to transform businesses and create meaningful user experiences. From concept to deployment, we ensure every project meets the highest standards of quality and performance.',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            height: 1.7,
          ),
          textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 32),

        // Key Points
        Column(
          crossAxisAlignment: isMobile || isTablet
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            _buildKeyPoint('Expert Development Team'),
            _buildKeyPoint('Cutting-edge Technologies'),
            _buildKeyPoint('Agile Development Process'),
            _buildKeyPoint('24/7 Support & Maintenance'),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isMobile, bool isTablet, AnimationController? animationController) {
    if (animationController == null) {
      return _buildStatsGridStatic(isMobile, isTablet);
    }

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : (isTablet ? 2 : 2),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: isMobile ? 1.2 : 1.5,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 800 + (index * 200)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: _buildStatCard(stats[index], isMobile),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGridStatic(bool isMobile, bool isTablet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : (isTablet ? 2 : 4),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 1.2 : 1.0,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return _buildStatCard(stats[index], isMobile);
      },
    );
  }

  Widget _buildStatCard(StatItem stat, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF1E40AF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.number,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 26 : 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 10 : 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StatItem {
  final String number;
  final String label;

  StatItem({required this.number, required this.label});
}
