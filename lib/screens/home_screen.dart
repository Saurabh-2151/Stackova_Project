import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/services_section.dart';
import '../widgets/about_section.dart';
import '../widgets/technologies_section.dart';
import '../widgets/portfolio_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false, // Allow hero section to extend to top
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(), // Prevent overscroll
              child: Column(
                children: [
                  const HeroSection(),
                  const ServicesSection(),
                  const AboutSection(),
                  const TechnologiesSection(),
                  const PortfolioSection(),
                  const ContactSection(),
                  const FooterSection(),
                ],
              ),
            ),
          CustomNavigationBar(
            isScrolled: _isScrolled,
            scrollController: _scrollController,
          ),
        ],
        ),
      ),
    );
  }
}
