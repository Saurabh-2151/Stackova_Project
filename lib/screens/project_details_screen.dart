import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/project_details/project_details_bloc.dart';
import '../bloc/project_details/project_details_event.dart';
import '../bloc/project_details/project_details_state.dart';
import '../models/project.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectDetailsBloc()..add(LoadProjectDetails(projectId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Project Details',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
          builder: (context, state) {
            if (state is ProjectDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF60A5FA)),
                ),
              );
            }

            if (state is ProjectDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Project',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60A5FA),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProjectDetailsLoaded) {
              return _ProjectDetailsContent(project: state.project);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProjectDetailsContent extends StatelessWidget {
  final Project project;

  const _ProjectDetailsContent({required this.project});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : (isTablet ? 24 : 32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header
          _buildProjectHeader(isMobile, isTablet),
          const SizedBox(height: 32),

          // Project Info Cards
          if (!isMobile) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildMainContent(isMobile, isTablet)),
                const SizedBox(width: 32),
                Expanded(flex: 1, child: _buildSidebar(isMobile, isTablet)),
              ],
            ),
          ] else ...[
            _buildMainContent(isMobile, isTablet),
            const SizedBox(height: 24),
            _buildSidebar(isMobile, isTablet),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectHeader(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              project.category,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            project.title,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.description,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          'Project Overview',
          Text(
            project.detailedDescription,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildSection(
          'Key Features',
          Column(
            children: project.features.map((feature) => _buildFeatureItem(feature)).toList(),
          ),
        ),
        const SizedBox(height: 32),
        _buildSection(
          'Technologies Used',
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies.map((tech) => _buildTechChip(tech)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(),
        const SizedBox(height: 24),
        if (project.githubUrl != null || project.liveUrl != null) ...[
          _buildLinksCard(),
          const SizedBox(height: 24),
        ],
        _buildProjectStats(),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF60A5FA),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String technology) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF60A5FA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF60A5FA).withOpacity(0.3)),
      ),
      child: Text(
        technology,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF60A5FA),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Information',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (project.clientName != null) _buildInfoRow('Client', project.clientName!),
          if (project.duration != null) _buildInfoRow('Duration', project.duration!),
          if (project.teamSize != null) _buildInfoRow('Team Size', project.teamSize!),
          _buildInfoRow('Category', project.category),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Links',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (project.githubUrl != null) _buildLinkButton('GitHub', FontAwesomeIcons.github, project.githubUrl!),
          if (project.liveUrl != null) _buildLinkButton('Live Demo', FontAwesomeIcons.externalLinkAlt, project.liveUrl!),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            // TODO: Launch URL
          },
          icon: FaIcon(icon, size: 16),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF60A5FA),
            side: const BorderSide(color: Color(0xFF60A5FA)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Stats',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Features', '${project.features.length}'),
          _buildStatRow('Technologies', '${project.technologies.length}'),
          _buildStatRow('Category', project.category),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
