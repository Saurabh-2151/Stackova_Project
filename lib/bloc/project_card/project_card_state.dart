import 'package:equatable/equatable.dart';

abstract class ProjectCardState extends Equatable {
  const ProjectCardState();

  @override
  List<Object> get props => [];
}

class ProjectCardInitial extends ProjectCardState {
  const ProjectCardInitial();
}

class ProjectCardLoaded extends ProjectCardState {
  final Map<String, bool> hoverStates;

  const ProjectCardLoaded({
    required this.hoverStates,
  });

  @override
  List<Object> get props => [hoverStates];

  bool isProjectHovered(String projectId) {
    return hoverStates[projectId] ?? false;
  }

  ProjectCardLoaded copyWith({
    Map<String, bool>? hoverStates,
  }) {
    return ProjectCardLoaded(
      hoverStates: hoverStates ?? this.hoverStates,
    );
  }
}
