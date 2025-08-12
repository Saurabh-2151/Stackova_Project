import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'screens/home_screen.dart';
import 'bloc/navigation/navigation_bloc.dart';
import 'bloc/hero/hero_bloc.dart';
import 'bloc/hero/hero_event.dart';
import 'bloc/visibility/visibility_bloc.dart';
import 'bloc/services/services_bloc.dart';
import 'bloc/portfolio/portfolio_bloc.dart';
import 'bloc/contact/contact_bloc.dart';
import 'bloc/project_card/project_card_bloc.dart';
import 'bloc/project_listing/project_listing_bloc.dart';
import 'widgets/error_boundary.dart';
import 'config/app_config.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const StackovaApp());
}

class StackovaApp extends StatelessWidget {
  const StackovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
        BlocProvider<HeroBloc>(
          create: (context) => HeroBloc()..add(const InitializeHero()),
        ),
        BlocProvider<VisibilityBloc>(create: (context) => VisibilityBloc()),
        BlocProvider<ServicesBloc>(create: (context) => ServicesBloc()),
        BlocProvider<PortfolioBloc>(create: (context) => PortfolioBloc()),
        BlocProvider<ContactBloc>(create: (context) => ContactBloc()),
        BlocProvider<ProjectCardBloc>(create: (context) => ProjectCardBloc()),
        BlocProvider<ProjectListingBloc>(
          create: (context) => ProjectListingBloc(),
        ),
      ],
      child: MaterialApp(
        title: '${AppConfig.companyName} - ${AppConfig.companyTagline}',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(AppConfig.primaryColorValue),
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(AppConfig.primaryColorValue),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: MaxWidthBox(
            maxWidth: 1920, // Prevent content from stretching too wide
            child: ClampingScrollWrapper.builder(context, child!),
          ),
          breakpoints: [
            const Breakpoint(start: 0, end: 599, name: MOBILE),
            const Breakpoint(start: 600, end: 1023, name: TABLET),
            const Breakpoint(start: 1024, end: 1439, name: DESKTOP),
            const Breakpoint(start: 1440, end: double.infinity, name: '4K'),
          ],
        ),
        home: const HomeScreen().withErrorBoundary(
          errorTitle: 'Application Error',
          errorMessage:
              'The application encountered an unexpected error. Please refresh the page to continue.',
        ),
      ),
    );
  }
}
