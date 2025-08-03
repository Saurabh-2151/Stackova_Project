import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final ScrollController scrollController = ScrollController();
  bool _isMenuOpen = false;

  NavigationBloc() : super(const NavigationInitial()) {
    on<ScrollPositionChanged>(_onScrollPositionChanged);
    on<NavigateToSection>(_onNavigateToSection);
    on<ToggleMobileMenu>(_onToggleMobileMenu);

    // Listen to scroll controller
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    add(ScrollPositionChanged(scrollController.offset));
  }

  void _onScrollPositionChanged(
    ScrollPositionChanged event,
    Emitter<NavigationState> emit,
  ) {
    final isScrolled = event.scrollOffset > 100;
    
    if (state is NavigationMobileMenuToggled) {
      final currentState = state as NavigationMobileMenuToggled;
      emit(NavigationMobileMenuToggled(
        isMenuOpen: currentState.isMenuOpen,
        isScrolled: isScrolled,
        scrollOffset: event.scrollOffset,
      ));
    } else {
      emit(NavigationScrolled(
        isScrolled: isScrolled,
        scrollOffset: event.scrollOffset,
      ));
    }
  }

  void _onNavigateToSection(
    NavigateToSection event,
    Emitter<NavigationState> emit,
  ) {
    scrollController.animateTo(
      event.targetOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _onToggleMobileMenu(
    ToggleMobileMenu event,
    Emitter<NavigationState> emit,
  ) {
    _isMenuOpen = !_isMenuOpen;
    
    final currentScrollOffset = scrollController.hasClients 
        ? scrollController.offset 
        : 0.0;
    final isScrolled = currentScrollOffset > 100;

    emit(NavigationMobileMenuToggled(
      isMenuOpen: _isMenuOpen,
      isScrolled: isScrolled,
      scrollOffset: currentScrollOffset,
    ));
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
