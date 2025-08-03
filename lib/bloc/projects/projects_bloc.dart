import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/project_data.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  late AnimationController animationController;

  ProjectsBloc() : super(const ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<FilterProjectsByCategory>(_onFilterProjectsByCategory);
    on<SearchProjects>(_onSearchProjects);
    on<ProjectsVisibilityChanged>(_onProjectsVisibilityChanged);
  }

  void initializeAnimationController(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
  }

  void _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) {
    emit(const ProjectsLoading());
    
    try {
      final allProjects = ProjectData.projects;
      final categories = ProjectData.categories;
      final selectedCategoryId = event.categoryId ?? 'all';
      
      List<Project> filteredProjects;
      if (selectedCategoryId == 'all') {
        filteredProjects = allProjects;
      } else {
        filteredProjects = allProjects
            .where((project) => project.categoryId == selectedCategoryId)
            .toList();
      }

      emit(ProjectsLoaded(
        allProjects: allProjects,
        filteredProjects: filteredProjects,
        categories: categories,
        selectedCategoryId: selectedCategoryId,
        searchQuery: '',
        isVisible: false,
      ));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  void _onFilterProjectsByCategory(
    FilterProjectsByCategory event,
    Emitter<ProjectsState> emit,
  ) {
    if (state is ProjectsLoaded) {
      final currentState = state as ProjectsLoaded;
      
      List<Project> filteredProjects;
      if (event.categoryId == 'all') {
        filteredProjects = currentState.allProjects;
      } else {
        filteredProjects = currentState.allProjects
            .where((project) => project.categoryId == event.categoryId)
            .toList();
      }

      // Apply search filter if there's a search query
      if (currentState.searchQuery.isNotEmpty) {
        filteredProjects = filteredProjects
            .where((project) => 
                project.title.toLowerCase().contains(currentState.searchQuery.toLowerCase()) ||
                project.description.toLowerCase().contains(currentState.searchQuery.toLowerCase()))
            .toList();
      }

      emit(currentState.copyWith(
        filteredProjects: filteredProjects,
        selectedCategoryId: event.categoryId,
      ));
    }
  }

  void _onSearchProjects(
    SearchProjects event,
    Emitter<ProjectsState> emit,
  ) {
    if (state is ProjectsLoaded) {
      final currentState = state as ProjectsLoaded;
      
      List<Project> baseProjects;
      if (currentState.selectedCategoryId == 'all') {
        baseProjects = currentState.allProjects;
      } else {
        baseProjects = currentState.allProjects
            .where((project) => project.categoryId == currentState.selectedCategoryId)
            .toList();
      }

      List<Project> filteredProjects;
      if (event.query.isEmpty) {
        filteredProjects = baseProjects;
      } else {
        filteredProjects = baseProjects
            .where((project) => 
                project.title.toLowerCase().contains(event.query.toLowerCase()) ||
                project.description.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
      }

      emit(currentState.copyWith(
        filteredProjects: filteredProjects,
        searchQuery: event.query,
      ));
    }
  }

  void _onProjectsVisibilityChanged(
    ProjectsVisibilityChanged event,
    Emitter<ProjectsState> emit,
  ) {
    if (state is ProjectsLoaded) {
      final currentState = state as ProjectsLoaded;
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
