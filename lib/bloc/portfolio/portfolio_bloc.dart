import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  late AnimationController animationController;

  PortfolioBloc() : super(const PortfolioInitial()) {
    on<LoadPortfolio>(_onLoadPortfolio);
    on<SelectCategory>(_onSelectCategory);
    on<PortfolioVisibilityChanged>(_onPortfolioVisibilityChanged);
  }

  void initializeAnimationController(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: vsync,
    );
  }

  void _onLoadPortfolio(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) {
    emit(const PortfolioLoading());
    
    try {
      final categories = ['All', 'Web Apps', 'Mobile Apps', 'UI/UX Design', 'Branding'];
      emit(PortfolioLoaded(
        categories: categories,
        selectedCategory: 'All',
        isVisible: false,
      ));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }

  void _onSelectCategory(
    SelectCategory event,
    Emitter<PortfolioState> emit,
  ) {
    if (state is PortfolioLoaded) {
      final currentState = state as PortfolioLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }

  void _onPortfolioVisibilityChanged(
    PortfolioVisibilityChanged event,
    Emitter<PortfolioState> emit,
  ) {
    if (state is PortfolioLoaded) {
      final currentState = state as PortfolioLoaded;
      emit(currentState.copyWith(isVisible: event.isVisible));
      
      if (event.isVisible) {
        animationController.forward();
      }
    }
  }

  @override
  Future<void> close() {
    animationController.dispose();
    return super.close();
  }
}
