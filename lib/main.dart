import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'screens/home_screen.dart';
import 'bloc/navigation/navigation_bloc.dart';
import 'bloc/hero/hero_bloc.dart';
import 'bloc/hero/hero_event.dart';

void main() {
  runApp(const StackovaApp());
}

class StackovaApp extends StatelessWidget {
  const StackovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider<HeroBloc>(
          create: (context) => HeroBloc()..add(const InitializeHero()),
        ),
      ],
      child: MaterialApp(
        title: 'Stackova - Professional Development Services',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF1E3A8A),
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
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
        home: const HomeScreen(),
      ),
    );
  }
}


