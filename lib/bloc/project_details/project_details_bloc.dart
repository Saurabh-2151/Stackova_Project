import 'package:flutter_bloc/flutter_bloc.dart';
import 'project_details_event.dart';
import 'project_details_state.dart';
import '../../models/project.dart';
import '../../data/projects_data.dart';

class ProjectDetailsBloc extends Bloc<ProjectDetailsEvent, ProjectDetailsState> {
  ProjectDetailsBloc() : super(const ProjectDetailsInitial()) {
    on<LoadProjectDetails>(_onLoadProjectDetails);
    on<ClearProjectDetails>(_onClearProjectDetails);
  }

  Future<void> _onLoadProjectDetails(
    LoadProjectDetails event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    emit(const ProjectDetailsLoading());

    try {
      // Simulate loading delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      // Find project by ID from all projects
      final allProjects = ProjectsData.getAllProjects();
      final project = allProjects.firstWhere(
        (p) => p.id == event.projectId,
        orElse: () => throw Exception('Project not found'),
      );

      emit(ProjectDetailsLoaded(project));
    } catch (e) {
      emit(ProjectDetailsError('Failed to load project details: ${e.toString()}'));
    }
  }

  void _onClearProjectDetails(
    ClearProjectDetails event,
    Emitter<ProjectDetailsState> emit,
  ) {
    emit(const ProjectDetailsInitial());
  }
}
