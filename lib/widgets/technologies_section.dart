import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/visibility/visibility_bloc.dart';
import '../bloc/visibility/visibility_event.dart';
import '../bloc/visibility/visibility_state.dart';

class TechnologiesSection extends StatefulWidget {
  const TechnologiesSection({super.key});

  @override
  State<TechnologiesSection> createState() => _TechnologiesSectionState();
}

class _TechnologiesSectionState extends State<TechnologiesSection>
    with TickerProviderStateMixin {
  static const String sectionId = 'technologies';

  final List<TechCategory> techCategories = [
    TechCategory(
      title: 'Frontend',
      technologies: [
        TechItem(name: 'React', icon: FontAwesomeIcons.react, color: const Color(0xFF61DAFB)),
        TechItem(name: 'Vue.js', icon: FontAwesomeIcons.vuejs, color: const Color(0xFF4FC08D)),
        TechItem(name: 'Angular', icon: FontAwesomeIcons.angular, color: const Color(0xFFDD0031)),
        TechItem(name: 'Flutter', icon: FontAwesomeIcons.google, color: const Color(0xFF02569B)),
      ],
    ),
    TechCategory(
      title: 'Backend',
      technologies: [
        TechItem(name: 'Node.js', icon: FontAwesomeIcons.nodeJs, color: const Color(0xFF339933)),
        TechItem(name: 'Python', icon: FontAwesomeIcons.python, color: const Color(0xFF3776AB)),
        TechItem(name: 'Java', icon: FontAwesomeIcons.java, color: const Color(0xFFED8B00)),
        TechItem(name: 'PHP', icon: FontAwesomeIcons.php, color: const Color(0xFF777BB4)),
      ],
    ),
    TechCategory(
      title: 'Mobile',
      technologies: [
        TechItem(name: 'React Native', icon: FontAwesomeIcons.react, color: const Color(0xFF61DAFB)),
        TechItem(name: 'Flutter', icon: FontAwesomeIcons.google, color: const Color(0xFF02569B)),
        TechItem(name: 'Swift', icon: FontAwesomeIcons.swift, color: const Color(0xFFFA7343)),
        TechItem(name: 'Kotlin', icon: FontAwesomeIcons.android, color: const Color(0xFF3DDC84)),
      ],
    ),
    TechCategory(
      title: 'Database',
      technologies: [
        TechItem(name: 'MongoDB', icon: FontAwesomeIcons.database, color: const Color(0xFF47A248)),
        TechItem(name: 'PostgreSQL', icon: FontAwesomeIcons.database, color: const Color(0xFF336791)),
        TechItem(name: 'MySQL', icon: FontAwesomeIcons.database, color: const Color(0xFF4479A1)),
        TechItem(name: 'Firebase', icon: FontAwesomeIcons.fire, color: const Color(0xFFFFCA28)),
      ],
    ),
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
      duration: const Duration(milliseconds: 2000),
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

        // Create tech animations
        final techAnimations = animationController != null
            ? List.generate(
                techCategories.length,
                (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
              )
            : <Animation<double>>[];

        return VisibilityDetector(
          key: const Key('technologies-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
          vertical: isMobile ? 60 : 100,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFE2E8F0),
            ],
          ),
        ),
        child: Column(
          children: [
            // Section Header
            AnimatedBuilder(
              animation: animationController ?? const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                final value = animationController?.value ?? 1.0;
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      children: [
                        Text(
                          'Technologies We Use',
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
                            'We leverage the latest and most powerful technologies to build robust, scalable, and future-proof solutions.',
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

            // Technologies Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: isMobile ? 1.2 : 0.9,
              ),
              itemCount: techCategories.length,
              itemBuilder: (context, index) {
                final animation = techAnimations.isNotEmpty && index < techAnimations.length
                    ? techAnimations[index]
                    : const AlwaysStoppedAnimation(1.0);

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        50 * (1 - animation.value),
                      ),
                      child: Opacity(
                        opacity: animation.value,
                        child: _buildTechCategoryCard(
                          techCategories[index],
                          isMobile,
                        ),
                      ),
                    );
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

  Widget _buildTechCategoryCard(TechCategory category, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Title
          Text(
            category.title,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 20),

          // Technologies
          Expanded(
            child: Column(
              children: category.technologies.map((tech) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTechItem(tech),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(TechItem tech) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: tech.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: tech.color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    tech.icon,
                    color: tech.color,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tech.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TechCategory {
  final String title;
  final List<TechItem> technologies;

  TechCategory({
    required this.title,
    required this.technologies,
  });
}

class TechItem {
  final String name;
  final IconData icon;
  final Color color;

  TechItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}
