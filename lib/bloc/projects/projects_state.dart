import 'package:equatable/equatable.dart';
import '../../models/project.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectsState {
  final List<Project> allProjects;
  final List<Project> filteredProjects;
  final List<String> categories;
  final String selectedCategoryId;
  final String searchQuery;
  final bool isVisible;

  const ProjectsLoaded({
    required this.allProjects,
    required this.filteredProjects,
    required this.categories,
    required this.selectedCategoryId,
    required this.searchQuery,
    required this.isVisible,
  });

  @override
  List<Object> get props => [
    allProjects,
    filteredProjects,
    categories,
    selectedCategoryId,
    searchQuery,
    isVisible,
  ];

  ProjectsLoaded copyWith({
    List<Project>? allProjects,
    List<Project>? filteredProjects,
    List<String>? categories,
    String? selectedCategoryId,
    String? searchQuery,
    bool? isVisible,
  }) {
    return ProjectsLoaded(
      allProjects: allProjects ?? this.allProjects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object> get props => [message];
}
