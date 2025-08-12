import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/projects_data.dart';
import '../../models/project.dart';
import 'project_listing_event.dart';
import 'project_listing_state.dart';

class ProjectListingBloc extends Bloc<ProjectListingEvent, ProjectListingState> {
  ProjectListingBloc() : super(const ProjectListingInitial()) {
    on<InitializeProjectListing>(_onInitializeProjectListing);
    on<ScrollPositionChanged>(_onScrollPositionChanged);
    on<CategoryFilterChanged>(_onCategoryFilterChanged);
  }

  void _onInitializeProjectListing(
    InitializeProjectListing event,
    Emitter<ProjectListingState> emit,
  ) async {
    try {
      // Emit loading state immediately
      emit(const ProjectListingLoading());

      // Load data asynchronously to avoid blocking UI
      await Future.delayed(const Duration(milliseconds: 50));

      final allProjects = ProjectsData.getAllProjectsExpanded();
      final filteredProjects = _filterProjectsByCategory(allProjects, event.categoryId);

      emit(ProjectListingLoaded(
        allProjects: allProjects,
        filteredProjects: filteredProjects,
        selectedCategory: event.categoryId,
      ));
    } catch (e) {
      emit(ProjectListingError(e.toString()));
    }
  }

  void _onScrollPositionChanged(
    ScrollPositionChanged event,
    Emitter<ProjectListingState> emit,
  ) {
    if (state is ProjectListingLoaded) {
      final currentState = state as ProjectListingLoaded;
      final isScrolled = event.scrollOffset > 100;
      
      if (currentState.isScrolled != isScrolled) {
        emit(currentState.copyWith(isScrolled: isScrolled));
      }
    }
  }

  void _onCategoryFilterChanged(
    CategoryFilterChanged event,
    Emitter<ProjectListingState> emit,
  ) {
    if (state is ProjectListingLoaded) {
      final currentState = state as ProjectListingLoaded;
      final filteredProjects = _filterProjectsByCategory(currentState.allProjects, event.categoryId);
      
      emit(currentState.copyWith(
        filteredProjects: filteredProjects,
        selectedCategory: event.categoryId,
      ));
    }
  }

  List<Project> _filterProjectsByCategory(List<Project> projects, String categoryId) {
    if (categoryId == 'all') {
      return projects;
    }
    
    // Map category IDs to actual category names
    String categoryName;
    switch (categoryId) {
      case 'web':
        categoryName = 'Web App';
        break;
      case 'android':
        categoryName = 'Android App';
        break;
      case 'ios':
        categoryName = 'iOS App';
        break;
      default:
        return projects;
    }
    
    return projects.where((project) => project.category == categoryName).toList();
  }
}
