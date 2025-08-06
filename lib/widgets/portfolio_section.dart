import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/portfolio/portfolio_bloc.dart';
import '../bloc/portfolio/portfolio_event.dart';
import '../bloc/portfolio/portfolio_state.dart';

class PortfolioSection extends StatefulWidget {
  const PortfolioSection({super.key});

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection>
    with TickerProviderStateMixin {

  final List<ProjectItem> projects = [
    ProjectItem(
      title: 'E-commerce Platform',
      description: 'Modern e-commerce solution with advanced features',
      category: 'E-commerce',
      technologies: ['React', 'Node.js', 'MongoDB'],
      imageUrl: 'https://via.placeholder.com/400x300/3B82F6/FFFFFF?text=E-commerce',
    ),
    ProjectItem(
      title: 'Task Management App',
      description: 'Collaborative task management mobile application',
      category: 'Mobile Apps',
      technologies: ['Flutter', 'Firebase', 'Dart'],
      imageUrl: 'https://via.placeholder.com/400x300/10B981/FFFFFF?text=Task+App',
    ),
    ProjectItem(
      title: 'Corporate Website',
      description: 'Professional corporate website with CMS',
      category: 'Web Apps',
      technologies: ['Vue.js', 'PHP', 'MySQL'],
      imageUrl: 'https://via.placeholder.com/400x300/8B5CF6/FFFFFF?text=Corporate',
    ),
    ProjectItem(
      title: 'Food Delivery App',
      description: 'Complete food delivery solution for restaurants',
      category: 'Mobile Apps',
      technologies: ['React Native', 'Express', 'PostgreSQL'],
      imageUrl: 'https://via.placeholder.com/400x300/F59E0B/FFFFFF?text=Food+App',
    ),
    ProjectItem(
      title: 'Learning Management System',
      description: 'Comprehensive LMS for educational institutions',
      category: 'Web Apps',
      technologies: ['Angular', 'Spring Boot', 'MySQL'],
      imageUrl: 'https://via.placeholder.com/400x300/EF4444/FFFFFF?text=LMS',
    ),
    ProjectItem(
      title: 'Fashion Store',
      description: 'Trendy fashion e-commerce with AR features',
      category: 'E-commerce',
      technologies: ['React', 'Python', 'PostgreSQL'],
      imageUrl: 'https://via.placeholder.com/400x300/EC4899/FFFFFF?text=Fashion',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the portfolio BLoC
    final portfolioBloc = context.read<PortfolioBloc>();
    portfolioBloc.add(const LoadPortfolio());
    portfolioBloc.initializeAnimationController(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3) {
      context.read<PortfolioBloc>().add(
        const PortfolioVisibilityChanged(true),
      );
    }
  }

  List<ProjectItem> getFilteredProjects(String selectedCategory) {
    if (selectedCategory == 'All') {
      return projects;
    }
    return projects.where((project) => project.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        final portfolioBloc = context.read<PortfolioBloc>();
        final animationController = portfolioBloc.animationController;

        if (state is! PortfolioLoaded) {
          return const SizedBox.shrink();
        }

        final filteredProjects = getFilteredProjects(state.selectedCategory);

        return VisibilityDetector(
          key: const Key('portfolio-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 100,
        ),
        color: Colors.white,
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
                          'Our Portfolio',
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
                            'Explore our recent projects and see how we\'ve helped businesses achieve their digital goals.',
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

            const SizedBox(height: 50),

            // Category Filter
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: animationController.value,
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: state.categories.map((category) {
                      final isSelected = state.selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          context.read<PortfolioBloc>().add(
                            SelectCategory(category),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFF3B82F6),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 50),

            // Projects Grid
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: GridView.builder(
                key: ValueKey(state.selectedCategory),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: isMobile ? 0.8 : 0.75,
                ),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final projectAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeOutCubic,
                    ),
                  );

                  return AnimatedBuilder(
                    animation: projectAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          50 * (1 - projectAnimation.value),
                        ),
                        child: Opacity(
                          opacity: projectAnimation.value,
                          child: _buildProjectCard(
                            filteredProjects[index],
                            isMobile,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildProjectCard(ProjectItem project, bool isMobile) {
    return Container(
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
        children: [
          // Project Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6).withValues(alpha: 0.8),
                    const Color(0xFF1E40AF).withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.web,
                  size: 60,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),

          // Project Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    project.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // Technologies
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies.map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tech,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectItem {
  final String title;
  final String description;
  final String category;
  final List<String> technologies;
  final String imageUrl;

  ProjectItem({
    required this.title,
    required this.description,
    required this.category,
    required this.technologies,
    required this.imageUrl,
  });
}
