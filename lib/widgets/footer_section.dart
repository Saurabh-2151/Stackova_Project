import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Column(
        children: [
          // Main Footer Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: isMobile ? 40 : 60,
            ),
            child: Column(
              children: [
                if (isMobile) ...[
                  // Mobile Layout
                  _buildCompanyInfo(isMobile),
                  const SizedBox(height: 40),
                  _buildQuickLinks(isMobile),
                  const SizedBox(height: 40),
                  _buildServices(isMobile),
                  const SizedBox(height: 40),
                  _buildContact(isMobile),
                ] else if (isTablet) ...[
                  // Tablet Layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildCompanyInfo(false)),
                      const SizedBox(width: 40),
                      Expanded(child: _buildQuickLinks(false)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildServices(false)),
                      const SizedBox(width: 40),
                      Expanded(child: _buildContact(false)),
                    ],
                  ),
                ] else ...[
                  // Desktop Layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildCompanyInfo(false)),
                      const SizedBox(width: 60),
                      Expanded(child: _buildQuickLinks(false)),
                      const SizedBox(width: 60),
                      Expanded(child: _buildServices(false)),
                      const SizedBox(width: 60),
                      Expanded(child: _buildContact(false)),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
            ),
            color: Colors.white.withValues(alpha: 0.1),
          ),

          // Bottom Footer
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: 24,
            ),
            child: Column(
              children: [
                if (isMobile) ...[
                  Text(
                    '© 2024 Stackova. All rights reserved.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  _buildSocialLinks(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2024 Stackova. All rights reserved.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      _buildSocialLinks(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.code,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Stackova',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            'We create innovative digital solutions that transform businesses and deliver exceptional user experiences.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.6,
            ),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(bool isMobile) {
    final links = ['Home', 'About', 'Services', 'Portfolio', 'Contact'];

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Links',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                link,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildServices(bool isMobile) {
    final services = [
      'Web Development',
      'Mobile Apps',
      'Custom Software',
      'UI/UX Design',
    ];

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                service,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildContact(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Info',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildContactItem(
          FontAwesomeIcons.envelope,
          'hello@stackova.com',
          isMobile,
        ),
        const SizedBox(height: 8),
        _buildContactItem(
          FontAwesomeIcons.phone,
          '+1 (555) 123-4567',
          isMobile,
        ),
        const SizedBox(height: 8),
        _buildContactItem(
          FontAwesomeIcons.locationDot,
          'Tech City, TC 12345',
          isMobile,
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, bool isMobile) {
    return Row(
      mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks() {
    final socialIcons = [
      FontAwesomeIcons.linkedin,
      FontAwesomeIcons.twitter,
      FontAwesomeIcons.github,
      FontAwesomeIcons.instagram,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialIcons.map((icon) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        );
      }).toList(),
    );
  }
}
