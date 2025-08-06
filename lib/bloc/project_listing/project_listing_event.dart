import 'package:equatable/equatable.dart';

abstract class ProjectListingEvent extends Equatable {
  const ProjectListingEvent();

  @override
  List<Object> get props => [];
}

class InitializeProjectListing extends ProjectListingEvent {
  final String categoryId;

  const InitializeProjectListing(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ScrollPositionChanged extends ProjectListingEvent {
  final double scrollOffset;

  const ScrollPositionChanged(this.scrollOffset);

  @override
  List<Object> get props => [scrollOffset];
}

class CategoryFilterChanged extends ProjectListingEvent {
  final String categoryId;

  const CategoryFilterChanged(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
