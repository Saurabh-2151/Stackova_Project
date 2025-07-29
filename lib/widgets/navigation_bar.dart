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
  late Animation<double> _fadeAnimation;
  bool _isMobileMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
            ? Colors.white.withOpacity(0.95)
            : Colors.transparent,
        boxShadow: widget.isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
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
                      color: widget.isScrolled ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Navigation Items
            if (!isMobile) ...[
              Row(
                children: [
                  _buildNavItem('Home', () => _scrollToSection(0)),
                  _buildNavItem('Services', () => _scrollToSection(800)),
                  _buildNavItem('About', () => _scrollToSection(1600)),
                  _buildNavItem('Technologies', () => _scrollToSection(2400)),
                  _buildNavItem('Portfolio', () => _scrollToSection(3200)),
                  _buildNavItem('Contact', () => _scrollToSection(4000)),
                ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.isScrolled ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
