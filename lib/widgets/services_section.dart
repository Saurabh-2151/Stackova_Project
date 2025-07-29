import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isVisible = false;

  final List<ServiceItem> services = [
    ServiceItem(
      icon: FontAwesomeIcons.globe,
      title: 'Web Application Development',
      description: 'Modern, responsive web applications built with cutting-edge technologies. From simple websites to complex enterprise solutions.',
      features: ['Responsive Design', 'Progressive Web Apps', 'E-commerce Solutions', 'CMS Development'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.android,
      title: 'Android Application Development',
      description: 'Native Android apps that deliver exceptional user experiences with optimal performance and seamless integration.',
      features: ['Native Android', 'Material Design', 'Play Store Optimization', 'Performance Tuning'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.apple,
      title: 'iOS Application Development',
      description: 'Beautiful iOS applications following Apple\'s design guidelines with smooth animations and intuitive interfaces.',
      features: ['Native iOS', 'Human Interface Guidelines', 'App Store Optimization', 'Core Data Integration'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.code,
      title: 'Custom Software Solutions',
      description: 'Tailored software solutions designed specifically for your business needs and requirements.',
      features: ['Custom Development', 'API Integration', 'Database Design', 'Cloud Solutions'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return VisibilityDetector(
      key: const Key('services-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 100,
        ),
        color: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            // Section Header
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _animationController.value)),
                  child: Opacity(
                    opacity: _animationController.value,
                    child: Column(
                      children: [
                        Text(
                          'Our Services',
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 600,
                          ),
                          child: Text(
                            'We offer comprehensive development services to bring your digital vision to life with cutting-edge technology and expert craftsmanship.',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Services Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (!isMobile && !isTablet) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: isMobile ? 0.7 : 0.8,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return _buildServiceCard(services[index], isMobile);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceItem service, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              service.icon,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            service.title,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            service.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),

          // Features
          Flexible(
            child: Column(
              children: service.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF10B981),
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;

  ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
  });
}
