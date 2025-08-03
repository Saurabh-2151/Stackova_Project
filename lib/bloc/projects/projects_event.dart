import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjects extends ProjectsEvent {
  final String? categoryId;

  const LoadProjects({this.categoryId});

  @override
  List<Object> get props => [categoryId ?? ''];
}

class FilterProjectsByCategory extends ProjectsEvent {
  final String categoryId;

  const FilterProjectsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SearchProjects extends ProjectsEvent {
  final String query;

  const SearchProjects(this.query);

  @override
  List<Object> get props => [query];
}

class ProjectsVisibilityChanged extends ProjectsEvent {
  final bool isVisible;

  const ProjectsVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}
