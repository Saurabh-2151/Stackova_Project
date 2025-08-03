import 'package:equatable/equatable.dart';

abstract class ProjectDetailsEvent extends Equatable {
  const ProjectDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjectDetails extends ProjectDetailsEvent {
  final String projectId;

  const LoadProjectDetails(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ClearProjectDetails extends ProjectDetailsEvent {
  const ClearProjectDetails();
}
