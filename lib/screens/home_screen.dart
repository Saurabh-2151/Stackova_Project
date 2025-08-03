import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/services_section.dart';
import '../widgets/about_section.dart';
import '../widgets/technologies_section.dart';
import '../widgets/portfolio_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../bloc/navigation/navigation_bloc.dart';
import '../bloc/navigation/navigation_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        final navigationBloc = context.read<NavigationBloc>();
        bool isScrolled = false;

        if (state is NavigationScrolled) {
          isScrolled = state.isScrolled;
        } else if (state is NavigationMobileMenuToggled) {
          isScrolled = state.isScrolled;
        }

        return Scaffold(
          body: SafeArea(
            top: false, // Allow hero section to extend to top
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: navigationBloc.scrollController,
                  physics: const ClampingScrollPhysics(), // Prevent overscroll
                  child: const Column(
                    children: [
                      HeroSection(),
                      ServicesSection(),
                      AboutSection(),
                      TechnologiesSection(),
                      PortfolioSection(),
                      ContactSection(),
                      FooterSection(),
                    ],
                  ),
                ),
                CustomNavigationBar(
                  isScrolled: isScrolled,
                  scrollController: navigationBloc.scrollController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
