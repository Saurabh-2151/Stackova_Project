import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/service_data.dart';
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  late AnimationController animationController;

  ServicesBloc() : super(const ServicesInitial()) {
    on<LoadServices>(_onLoadServices);
    on<ServiceCardTapped>(_onServiceCardTapped);
    on<ServicesVisibilityChanged>(_onServicesVisibilityChanged);
  }

  void initializeAnimationController(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
  }

  void _onLoadServices(
    LoadServices event,
    Emitter<ServicesState> emit,
  ) {
    emit(const ServicesLoading());
    
    try {
      final services = ServiceData.services;
      emit(ServicesLoaded(
        services: services,
        isVisible: false,
      ));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  void _onServiceCardTapped(
    ServiceCardTapped event,
    Emitter<ServicesState> emit,
  ) {
    if (state is ServicesLoaded) {
      final currentState = state as ServicesLoaded;
      
      // Navigate to project listing screen
      // This would typically be handled by a navigation service or router
      emit(currentState.copyWith(selectedServiceId: event.serviceId));
    }
  }

  void _onServicesVisibilityChanged(
    ServicesVisibilityChanged event,
    Emitter<ServicesState> emit,
  ) {
    if (state is ServicesLoaded) {
      final currentState = state as ServicesLoaded;
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
