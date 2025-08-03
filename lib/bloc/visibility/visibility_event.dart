import 'package:equatable/equatable.dart';

abstract class VisibilityEvent extends Equatable {
  const VisibilityEvent();

  @override
  List<Object> get props => [];
}

class SectionVisibilityChanged extends VisibilityEvent {
  final String sectionId;
  final bool isVisible;

  const SectionVisibilityChanged({
    required this.sectionId,
    required this.isVisible,
  });

  @override
  List<Object> get props => [sectionId, isVisible];
}

class InitializeSection extends VisibilityEvent {
  final String sectionId;

  const InitializeSection(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}
