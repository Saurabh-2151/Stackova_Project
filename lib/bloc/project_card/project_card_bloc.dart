import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'project_card_event.dart';
import 'project_card_state.dart';

class ProjectCardBloc extends Bloc<ProjectCardEvent, ProjectCardState> {
  final Map<String, AnimationController> _animationControllers = {};

  ProjectCardBloc() : super(const ProjectCardInitial()) {
    on<InitializeProjectCard>(_onInitializeProjectCard);
    on<ProjectCardHoverChanged>(_onProjectCardHoverChanged);
    on<ProjectCardTapped>(_onProjectCardTapped);
  }

  void initializeAnimationController(String projectId, TickerProvider vsync) {
    _animationControllers[projectId] = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: vsync,
    );
  }

  AnimationController? getAnimationController(String projectId) {
    return _animationControllers[projectId];
  }

  void _onInitializeProjectCard(
    InitializeProjectCard event,
    Emitter<ProjectCardState> emit,
  ) {
    final currentMap = state is ProjectCardLoaded 
        ? (state as ProjectCardLoaded).hoverStates 
        : <String, bool>{};
    
    final newMap = Map<String, bool>.from(currentMap);
    newMap[event.projectId] = false;
    
    emit(ProjectCardLoaded(hoverStates: newMap));
  }

  void _onProjectCardHoverChanged(
    ProjectCardHoverChanged event,
    Emitter<ProjectCardState> emit,
  ) {
    final currentMap = state is ProjectCardLoaded 
        ? (state as ProjectCardLoaded).hoverStates 
        : <String, bool>{};
    
    final newMap = Map<String, bool>.from(currentMap);
    newMap[event.projectId] = event.isHovered;
    
    emit(ProjectCardLoaded(hoverStates: newMap));
    
    // Trigger animation
    final controller = _animationControllers[event.projectId];
    if (controller != null) {
      if (event.isHovered) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  void _onProjectCardTapped(
    ProjectCardTapped event,
    Emitter<ProjectCardState> emit,
  ) {
    // Handle project card tap - this could trigger navigation
    // The actual navigation should be handled by the UI layer
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
