import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'visibility_event.dart';
import 'visibility_state.dart';

class VisibilityBloc extends Bloc<VisibilityEvent, VisibilityState> {
  final Map<String, AnimationController> _animationControllers = {};
  
  VisibilityBloc() : super(const VisibilityInitial()) {
    on<InitializeSection>(_onInitializeSection);
    on<SectionVisibilityChanged>(_onSectionVisibilityChanged);
  }

  void initializeAnimationController(String sectionId, TickerProvider vsync, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    _animationControllers[sectionId] = AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  AnimationController? getAnimationController(String sectionId) {
    return _animationControllers[sectionId];
  }

  void _onInitializeSection(
    InitializeSection event,
    Emitter<VisibilityState> emit,
  ) {
    final currentMap = state is SectionVisibilityUpdated 
        ? (state as SectionVisibilityUpdated).visibilityMap 
        : <String, bool>{};
    
    final newMap = Map<String, bool>.from(currentMap);
    newMap[event.sectionId] = false;
    
    emit(SectionVisibilityUpdated(newMap));
  }

  void _onSectionVisibilityChanged(
    SectionVisibilityChanged event,
    Emitter<VisibilityState> emit,
  ) {
    final currentMap = state is SectionVisibilityUpdated 
        ? (state as SectionVisibilityUpdated).visibilityMap 
        : <String, bool>{};
    
    final newMap = Map<String, bool>.from(currentMap);
    newMap[event.sectionId] = event.isVisible;
    
    emit(SectionVisibilityUpdated(newMap));
    
    // Trigger animation if section becomes visible
    if (event.isVisible && _animationControllers.containsKey(event.sectionId)) {
      _animationControllers[event.sectionId]?.forward();
    }
  }

  @override
  Future<void> close() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    _animationControllers.clear();
    return super.close();
  }
}
