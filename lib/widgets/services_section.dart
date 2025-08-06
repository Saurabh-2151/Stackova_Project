import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../screens/project_listing_screen.dart';
import '../bloc/services/services_bloc.dart';
import '../bloc/services/services_event.dart';
import '../bloc/services/services_state.dart';
import '../data/comprehensive_projects_database.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {

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
      icon: FontAwesomeIcons.robot,
      title: 'AI & Machine Learning Solutions',
      description: 'Intelligent systems powered by artificial intelligence and machine learning algorithms for automation and insights.',
      features: ['Computer Vision', 'Natural Language Processing', 'Predictive Analytics', 'AI Chatbots'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.link,
      title: 'Blockchain & Cryptocurrency',
      description: 'Decentralized applications, smart contracts, and blockchain-based solutions for secure and transparent systems.',
      features: ['Smart Contracts', 'DeFi Platforms', 'NFT Marketplaces', 'Cryptocurrency Wallets'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.cube,
      title: 'AR & VR Development',
      description: 'Immersive augmented and virtual reality experiences for education, training, and entertainment.',
      features: ['AR Applications', 'VR Simulations', 'Mixed Reality', '3D Modeling'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.chartLine,
      title: 'Data Science & Analytics',
      description: 'Data-driven insights and analytics platforms to help businesses make informed decisions.',
      features: ['Business Intelligence', 'Data Visualization', 'Predictive Modeling', 'Big Data Processing'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.microchip,
      title: 'IoT & Embedded Systems',
      description: 'Internet of Things solutions and embedded systems for smart devices and automation.',
      features: ['Smart Home Systems', 'Industrial IoT', 'Sensor Networks', 'Edge Computing'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.shield,
      title: 'Cybersecurity Solutions',
      description: 'Comprehensive security solutions to protect your digital assets and ensure data privacy.',
      features: ['Network Security', 'Threat Detection', 'Security Audits', 'Compliance Management'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.cloud,
      title: 'Cloud & DevOps',
      description: 'Cloud infrastructure and DevOps solutions for scalable, reliable, and efficient software deployment.',
      features: ['Cloud Migration', 'CI/CD Pipelines', 'Infrastructure as Code', 'Monitoring & Analytics'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.creditCard,
      title: 'FinTech Solutions',
      description: 'Financial technology solutions including digital banking, payment systems, and investment platforms.',
      features: ['Digital Banking', 'Payment Gateways', 'Robo-Advisors', 'Cryptocurrency Trading'],
    ),
    ServiceItem(
      icon: FontAwesomeIcons.graduationCap,
      title: 'EdTech Platforms',
      description: 'Educational technology solutions for online learning, student management, and digital classrooms.',
      features: ['Learning Management Systems', 'Virtual Classrooms', 'Educational Games', 'Student Analytics'],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the services BLoC
    final servicesBloc = context.read<ServicesBloc>();
    servicesBloc.add(const LoadServices());
    servicesBloc.initializeAnimationController(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3) {
      context.read<ServicesBloc>().add(
        const ServicesVisibilityChanged(true),
      );
    }
  }

  void _navigateToProjectListing(ServiceItem service) {
    String projectType = 'all';
    IconData icon = FontAwesomeIcons.code;
    Color color = const Color(0xFF3B82F6);

    if (service.title.contains('Web')) {
      projectType = 'web';
      icon = FontAwesomeIcons.globe;
      color = const Color(0xFF10B981);
    } else if (service.title.contains('Android')) {
      projectType = 'android';
      icon = FontAwesomeIcons.android;
      color = const Color(0xFFA3E635);
    } else if (service.title.contains('iOS')) {
      projectType = 'ios';
      icon = FontAwesomeIcons.apple;
      color = const Color(0xFF6366F1);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectListingScreen(
          projectType: projectType,
          title: service.title,
          icon: icon,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        final servicesBloc = context.read<ServicesBloc>();
        final animationController = servicesBloc.animationController;

        return VisibilityDetector(
          key: const Key('services-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : (isTablet ? 32 : 64),
          vertical: isMobile ? 40 : (isTablet ? 60 : 80),
        ),
        color: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            // Section Header
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - animationController.value)),
                  child: Opacity(
                    opacity: animationController.value,
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
                        SizedBox(height: isMobile ? 12 : 16),
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

            SizedBox(height: isMobile ? 40 : (isTablet ? 50 : 60)),

            // Services Grid - Fully Responsive
            LayoutBuilder(
              builder: (context, constraints) {
                // Enhanced responsive breakpoints
                int crossAxisCount = 1;
                double childAspectRatio = 1.0;
                double crossAxisSpacing = 15;
                double mainAxisSpacing = 15;

                // Ultra-wide screens (1440px+)
                if (constraints.maxWidth >= 1440) {
                  crossAxisCount = 4;
                  childAspectRatio = 1.1;
                  crossAxisSpacing = 24;
                  mainAxisSpacing = 24;
                }
                // Large desktop (1200px-1439px)
                else if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 3;
                  childAspectRatio = 1.0;
                  crossAxisSpacing = 20;
                  mainAxisSpacing = 20;
                }
                // Desktop/laptop (1024px-1199px)
                else if (constraints.maxWidth >= 1024) {
                  crossAxisCount = 2;
                  childAspectRatio = 0.9;
                  crossAxisSpacing = 20;
                  mainAxisSpacing = 20;
                }
                // Large tablet (768px-1023px)
                else if (constraints.maxWidth >= 768) {
                  crossAxisCount = 2;
                  childAspectRatio = 0.8;
                  crossAxisSpacing = 16;
                  mainAxisSpacing = 16;
                }
                // Small tablet/large phone (600px-767px)
                else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 1;
                  childAspectRatio = 1.8;
                  crossAxisSpacing = 12;
                  mainAxisSpacing = 12;
                }
                // Mobile phones (320px-599px)
                else {
                  crossAxisCount = 1;
                  childAspectRatio = 1.6;
                  crossAxisSpacing = 12;
                  mainAxisSpacing = 12;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return _buildServiceCard(services[index], constraints.maxWidth);
                  },
                );
              },
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildServiceCard(ServiceItem service, double screenWidth) {
    // Responsive sizing based on screen width
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    return GestureDetector(
      onTap: () => _navigateToProjectListing(service),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isMobile ? 12 : (isTablet ? 16 : 20)), // Responsive padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
              width: isMobile ? 40 : (isTablet ? 48 : 56), // Responsive size
              height: isMobile ? 40 : (isTablet ? 48 : 56), // Responsive size
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                service.icon,
                color: Colors.white,
                size: isMobile ? 20 : (isTablet ? 24 : 28), // Responsive icon size
              ),
            ),

            SizedBox(height: isMobile ? 8 : (isTablet ? 12 : 16)), // Responsive spacing

            // Title
            Text(
              service.title,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 16 : (isTablet ? 18 : 20), // Responsive font size
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: isMobile ? 6 : (isTablet ? 8 : 10)), // Responsive spacing

            // Description
            Text(
              service.description,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 12 : (isTablet ? 14 : 16), // Responsive font size
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              maxLines: isMobile ? 3 : 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: isMobile ? 4 : (isTablet ? 6 : 8)), // Responsive spacing

            // Features
            Flexible(
              child: Column(
                children: service.features.map((feature) => Padding(
                      padding: EdgeInsets.only(bottom: isMobile ? 2 : (isTablet ? 3 : 4)), // Responsive padding
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF10B981),
                            size: isMobile ? 10 : (isTablet ? 12 : 14), // Responsive icon size
                          ),
                          SizedBox(width: isMobile ? 4 : (isTablet ? 6 : 8)), // Responsive spacing
                          Expanded(
                            child: Text(
                              feature,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 10 : (isTablet ? 11 : 12), // Responsive font size
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF374151),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
              ),
            ),
          ],
        ),
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