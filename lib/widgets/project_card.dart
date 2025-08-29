import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../models/project.dart';
import '../screens/project_details_screen.dart';
import '../bloc/project_card/project_card_bloc.dart';
import '../bloc/project_card/project_card_event.dart';
import '../bloc/project_card/project_card_state.dart';
import '../utils/analytics_helper.dart';
import '../utils/performance_monitor.dart';


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



  void _onTap() {
    // Track analytics
    AnalyticsHelper().trackProjectView(widget.project.id, widget.project.title);
    AnalyticsHelper().trackUserInteraction('tap', 'project_card', parameters: {
      'project_id': widget.project.id,
      'project_title': widget.project.title,
    });

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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ultra-compact design
                        Padding(
                          padding: EdgeInsets.all(widget.isCompact ? 4 : 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Category and title in one line
                              Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height : 15,
                                    // padding: EdgeInsets.symmetric(
                                    //   horizontal: widget.isCompact ? 3 : 4,
                                    //   vertical: widget.isCompact ? 1 : 2,
                                    // ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      widget.project.category.substring(0, 1).toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: widget.isCompact ? 6 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.project.title,
                                      style: GoogleFonts.inter(
                                        fontSize: widget.isCompact ? 8 : 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1E293B),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: widget.isCompact ? 2 : 3),

                              // Description (very short)
                              Text(
                                widget.project.description,
                                style: GoogleFonts.inter(
                                  fontSize: widget.isCompact ? 7 : 12,
                                  color: Colors.grey[600],
                                  height: 1.1,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: widget.isCompact ? 2 : 3),

                              // Single tech chip
                              if (widget.project.technologies.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widget.isCompact ? 2 : 3,
                                    vertical: widget.isCompact ? 1 : 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF60A5FA).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    widget.project.technologies.first,
                                    style: GoogleFonts.inter(
                                      fontSize: widget.isCompact ? 6 : 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF60A5FA),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),

                              SizedBox(height: widget.isCompact ? 2 : 8),

                              // Minimal button
                              SizedBox(
                                width: double.infinity,
                                height: widget.isCompact ? 16 : 40,
                                child: OutlinedButton(
                                  onPressed: _onTap,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF60A5FA),
                                    side: BorderSide(
                                      color: const Color(0xFF60A5FA),
                                      width: 0.5,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: widget.isCompact ? 4 : 6,
                                      vertical: 0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  child: Text(
                                    'View',
                                    style: GoogleFonts.inter(
                                      fontSize: widget.isCompact ? 7 : 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
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




}
