import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomNavigationBar extends StatefulWidget {
  final bool isScrolled;
  final ScrollController scrollController;

  const CustomNavigationBar({
    super.key,
    required this.isScrolled,
    required this.scrollController,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isMobileMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToSection(double offset) {
    widget.scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    if (_isMobileMenuOpen) {
      setState(() {
        _isMobileMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      decoration: BoxDecoration(
        color: widget.isScrolled
            ? Colors.white.withValues(alpha: 0.95)
            : Colors.transparent,
        boxShadow: widget.isScrolled
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
            GestureDetector(
              onTap: () => _scrollToSection(0),
              child: Row(
                children: [
                  Container(
                    width: isMobile ? 40 : 50,
                    height: isMobile ? 40 : 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // Add subtle shadow for better visibility
                      boxShadow: widget.isScrolled ? [
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
                        color: widget.isScrolled ? Colors.black : Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            // Navigation Items
            if (!isMobile) ...[
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem('Home', () => _scrollToSection(0)),
                    _buildNavItem('Services', () => _scrollToSection(800)),
                    _buildNavItem('About', () => _scrollToSection(1600)),
                    _buildNavItem('Technologies', () => _scrollToSection(2400)),
                    _buildNavItem('Portfolio', () => _scrollToSection(3200)),
                    _buildNavItem('Contact', () => _scrollToSection(4000)),
                  ],
                ),
              ),
            ] else ...[
              // Mobile Menu Button
              IconButton(
                onPressed: () {
                  setState(() {
                    _isMobileMenuOpen = !_isMobileMenuOpen;
                  });
                },
                icon: Icon(
                  _isMobileMenuOpen ? Icons.close : Icons.menu,
                  color: widget.isScrolled ? Colors.black : Colors.white,
                  size: 28,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 20),
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
              color: widget.isScrolled ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}