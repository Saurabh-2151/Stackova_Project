import 'package:equatable/equatable.dart';
import '../../models/project.dart';

abstract class ProjectListingState extends Equatable {
  const ProjectListingState();

  @override
  List<Object> get props => [];
}

class ProjectListingInitial extends ProjectListingState {
  const ProjectListingInitial();
}

class ProjectListingLoading extends ProjectListingState {
  const ProjectListingLoading();
}

class ProjectListingLoaded extends ProjectListingState {
  final List<Project> allProjects;
  final List<Project> filteredProjects;
  final String selectedCategory;
  final bool isScrolled;

  const ProjectListingLoaded({
    required this.allProjects,
    required this.filteredProjects,
    required this.selectedCategory,
    this.isScrolled = false,
  });

  @override
  List<Object> get props => [allProjects, filteredProjects, selectedCategory, isScrolled];

  ProjectListingLoaded copyWith({
    List<Project>? allProjects,
    List<Project>? filteredProjects,
    String? selectedCategory,
    bool? isScrolled,
  }) {
    return ProjectListingLoaded(
      allProjects: allProjects ?? this.allProjects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isScrolled: isScrolled ?? this.isScrolled,
    );
  }
}

class ProjectListingError extends ProjectListingState {
  final String message;

  const ProjectListingError(this.message);

  @override
  List<Object> get props => [message];
}
