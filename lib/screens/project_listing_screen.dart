import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/project.dart';
import '../data/projects_data.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/project_card.dart';
import '../bloc/project_listing/project_listing_bloc.dart';
import '../bloc/project_listing/project_listing_event.dart';
import '../bloc/project_listing/project_listing_state.dart';

class ProjectListingScreen extends StatefulWidget {
  final String projectType;
  final String title;
  final IconData icon;
  final Color color;

  const ProjectListingScreen({
    super.key,
    required this.projectType,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<ProjectListingScreen> createState() => _ProjectListingScreenState();
}

class _ProjectListingScreenState extends State<ProjectListingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize the project listing BLoC
    final categoryId = _getCategoryId(widget.projectType);
    context.read<ProjectListingBloc>().add(InitializeProjectListing(categoryId));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    context.read<ProjectListingBloc>().add(
      ScrollPositionChanged(_scrollController.offset),
    );
  }

  String _getCategoryId(String projectType) {
    switch (projectType) {
      case 'web':
        return 'web';
      case 'android':
        return 'android';
      case 'ios':
        return 'ios';
      default:
        return 'all';
    }
  }

  void _filterByCategory(String categoryId) {
    context.read<ProjectListingBloc>().add(
      CategoryFilterChanged(categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return BlocBuilder<ProjectListingBloc, ProjectListingState>(
      builder: (context, state) {
        if (state is! ProjectListingLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(), // Prevent overscroll
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(isMobile, isTablet, state),

                    // Category Filters (only for "All Software Projects")
                    if (widget.projectType == 'all') ...[
                      _buildCategoryFilters(isMobile, isTablet, state),
                      const SizedBox(height: 40),
                    ],

                    // Projects List
                    _buildProjectsList(isMobile, isTablet, state),

                    const SizedBox(height: 80),
                  ],
                ),
                ),
                CustomNavigationBar(
                  isScrolled: state.isScrolled,
                  scrollController: _scrollController,
                ),
              ],
              ),
            ),
          );
        },
      );
  }

  Widget _buildHeroSection(bool isMobile, bool isTablet, ProjectListingLoaded state) {
    return Container(
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.color,
            widget.color.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back Button
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 40,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              widget.title,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Project Count
            Text(
              '${state.allProjects.length} Projects Available',
              style: GoogleFonts.inter(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(bool isMobile, bool isTablet, ProjectListingLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Text(
            'Project Categories',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildCategoryChip('all', 'All Categories', isMobile, state),
              _buildCategoryChip('web', 'Web Apps', isMobile, state),
              _buildCategoryChip('android', 'Android Apps', isMobile, state),
              _buildCategoryChip('ios', 'iOS Apps', isMobile, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String categoryId, String name, bool isMobile, ProjectListingLoaded state) {
    final isSelected = state.selectedCategory == categoryId;
    
    return GestureDetector(
      onTap: () => _filterByCategory(categoryId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: isMobile ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? widget.color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? widget.color : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          name,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsList(bool isMobile, bool isTablet, ProjectListingLoaded state) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projects (${state.filteredProjects.length})',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              if (state.selectedCategory != 'all')
                GestureDetector(
                  onTap: () => _filterByCategory('all'),
                  child: Text(
                    'Clear Filter',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.color,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Projects Grid
          if (state.filteredProjects.isEmpty)
            _buildEmptyState()
          else
            LayoutBuilder(
              builder: (context, constraints) {
                // Enhanced responsive grid for project listing
                int crossAxisCount = 1;
                double childAspectRatio = 1.3;
                double spacing = 16;

                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 4;
                  childAspectRatio = 1.1;
                  spacing = 20;
                } else if (constraints.maxWidth >= 900) {
                  crossAxisCount = 3;
                  childAspectRatio = 1.2;
                  spacing = 18;
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 2;
                  childAspectRatio = 1.25;
                  spacing = 16;
                } else {
                  crossAxisCount = 1;
                  childAspectRatio = 1.4;
                  spacing = 12;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: state.filteredProjects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(
                      project: state.filteredProjects[index],
                      isCompact: constraints.maxWidth < 600,
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            Text(
              'No projects found',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different category',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
