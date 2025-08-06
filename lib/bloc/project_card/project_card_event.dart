import 'package:equatable/equatable.dart';

abstract class ProjectCardEvent extends Equatable {
  const ProjectCardEvent();

  @override
  List<Object> get props => [];
}

class InitializeProjectCard extends ProjectCardEvent {
  final String projectId;

  const InitializeProjectCard(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class ProjectCardHoverChanged extends ProjectCardEvent {
  final String projectId;
  final bool isHovered;

  const ProjectCardHoverChanged({
    required this.projectId,
    required this.isHovered,
  });

  @override
  List<Object> get props => [projectId, isHovered];
}

class ProjectCardTapped extends ProjectCardEvent {
  final String projectId;

  const ProjectCardTapped(this.projectId);

  @override
  List<Object> get props => [projectId];
}
