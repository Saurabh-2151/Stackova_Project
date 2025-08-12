import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_event.dart';
import '../bloc/navigation/navigation_state.dart';

class CustomNavigationBar extends StatelessWidget {
  final bool isScrolled;
  final ScrollController scrollController;

  const CustomNavigationBar({
    super.key,
    required this.isScrolled,
    required this.scrollController,
  });

  void _scrollToSection(BuildContext context, double offset) {
    context.read<NavigationBloc>().add(NavigateToSection(offset));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        final isMobile = ResponsiveBreakpoints.of(context).isMobile;
        bool isMobileMenuOpen = false;

        if (state is NavigationMobileMenuToggled) {
          isMobileMenuOpen = state.isMenuOpen;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80,
          decoration: BoxDecoration(
            color: isScrolled
                ? Colors.white.withValues(alpha: 0.95)
                : Colors.transparent,
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Semantics(
              label: 'Stackova logo, tap to go to home section',
              button: true,
              child: GestureDetector(
                onTap: () => _scrollToSection(context, 0),
                child: Row(
                  children: [
                  Container(
                    width: isMobile ? 40 : 50,
                    height: isMobile ? 40 : 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // Add subtle shadow for better visibility
                      boxShadow: isScrolled ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high, // Better image quality
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to icon if image fails to load
                          return Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.code,
                              color: Colors.white,
                              size: isMobile ? 20 : 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: isMobile ? 2 : 6),
                  if (!isMobile || MediaQuery.of(context).size.width > 350) // Hide text on very small screens
                    Text(
                      'Stackova',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: isScrolled ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Items
            if (!isMobile) ...[
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(context, 'Home', () => _scrollToSection(context, 0)),
                    _buildNavItem(context, 'Services', () => _scrollToSection(context, 800)),
                    _buildNavItem(context, 'About', () => _scrollToSection(context, 1600)),
                    _buildNavItem(context, 'Technologies', () => _scrollToSection(context, 2400)),
                    _buildNavItem(context, 'Portfolio', () => _scrollToSection(context, 3200)),
                    _buildNavItem(context, 'Contact', () => _scrollToSection(context, 4000)),
                  ],
                ),
              ),
            ] else ...[
              // Mobile Menu Button
              Semantics(
                label: isMobileMenuOpen ? 'Close navigation menu' : 'Open navigation menu',
                button: true,
                child: IconButton(
                  onPressed: () {
                    context.read<NavigationBloc>().add(const ToggleMobileMenu());
                  },
                  icon: Icon(
                    isMobileMenuOpen ? Icons.close : Icons.menu,
                    color: isScrolled ? Colors.black : Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, String title, VoidCallback onTap) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 20),
      child: Semantics(
        label: 'Navigate to $title section',
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44), // Touch-friendly
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: isTablet ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: isScrolled ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}