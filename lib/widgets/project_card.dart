import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/project.dart';
import '../screens/project_details_screen.dart';
import '../bloc/project_card/project_card_bloc.dart';
import '../bloc/project_card/project_card_event.dart';
import '../bloc/project_card/project_card_state.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final bool isCompact;

  const ProjectCard({
    super.key,
    required this.project,
    this.isCompact = false,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    // Initialize the project card in BLoC
    final projectCardBloc = context.read<ProjectCardBloc>();
    projectCardBloc.add(InitializeProjectCard(widget.project.id));
    projectCardBloc.initializeAnimationController(widget.project.id, this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectDetailsScreen(projectId: widget.project.id),
      ),
    );
  }

  void _onHover(bool isHovered) {
    context.read<ProjectCardBloc>().add(
      ProjectCardHoverChanged(
        projectId: widget.project.id,
        isHovered: isHovered,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return BlocBuilder<ProjectCardBloc, ProjectCardState>(
      builder: (context, state) {
        final projectCardBloc = context.read<ProjectCardBloc>();
        final animationController = projectCardBloc.getAnimationController(widget.project.id);
        final isHovered = state is ProjectCardLoaded ? state.isProjectHovered(widget.project.id) : false;

        if (animationController == null) {
          return _buildStaticCard(isMobile, isHovered);
        }

        final scaleAnimation = Tween<double>(
          begin: 1.0,
          end: 1.02,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ));

        final elevationAnimation = Tween<double>(
          begin: 2.0,
          end: 8.0,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ));

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTap: _onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Card(
                  elevation: elevationAnimation.value,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isHovered
                            ? const Color(0xFF60A5FA).withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project Image Placeholder
                        Container(
                          height: widget.isCompact ? 120 : 160,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF60A5FA).withOpacity(0.8),
                                const Color(0xFF3B82F6).withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Background pattern
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: _ProjectCardPatternPainter(),
                                ),
                              ),
                              // Category badge
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.project.category,
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF3B82F6),
                                    ),
                                  ),
                                ),
                              ),
                              // Click indicator
                              if (isHovered)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Project Content
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(widget.isCompact ? 16 : 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Project Title
                                Text(
                                  widget.project.title,
                                  style: GoogleFonts.inter(
                                    fontSize: widget.isCompact ? 16 : 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Project Description
                                Expanded(
                                  child: Text(
                                    widget.project.description,
                                    style: GoogleFonts.inter(
                                      fontSize: widget.isCompact ? 13 : 14,
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                    maxLines: widget.isCompact ? 2 : 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Technologies
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: widget.project.technologies
                                      .take(3)
                                      .map((tech) => _buildTechChip(tech))
                                      .toList(),
                                ),
                                
                                if (widget.project.technologies.length > 3) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    '+${widget.project.technologies.length - 3} more',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                                
                                const SizedBox(height: 16),
                                
                                // View Details Button
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _onTap,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF60A5FA),
                                      side: BorderSide(
                                        color: isHovered
                                            ? const Color(0xFF60A5FA)
                                            : Colors.grey[300]!,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'View Details',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: isHovered
                                              ? const Color(0xFF60A5FA)
                                              : Colors.grey[500],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
          },
        );
      },
    );
  }

  Widget _buildStaticCard(bool isMobile, bool isHovered) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: _onTap,
        child: Card(
          elevation: isHovered ? 8.0 : 2.0,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isHovered
                    ? const Color(0xFF60A5FA).withValues(alpha: 0.3)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project content would go here - simplified for static version
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.project.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechChip(String technology) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF60A5FA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        technology,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF60A5FA),
        ),
      ),
    );
  }
}

class _ProjectCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw a subtle grid pattern
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
