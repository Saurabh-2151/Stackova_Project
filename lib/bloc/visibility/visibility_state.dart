import 'package:equatable/equatable.dart';

abstract class VisibilityState extends Equatable {
  const VisibilityState();

  @override
  List<Object> get props => [];
}

class VisibilityInitial extends VisibilityState {
  const VisibilityInitial();
}

class SectionVisibilityUpdated extends VisibilityState {
  final Map<String, bool> visibilityMap;

  const SectionVisibilityUpdated(this.visibilityMap);

  @override
  List<Object> get props => [visibilityMap];

  bool isSectionVisible(String sectionId) {
    return visibilityMap[sectionId] ?? false;
  }

  SectionVisibilityUpdated copyWith({
    Map<String, bool>? visibilityMap,
  }) {
    return SectionVisibilityUpdated(
      visibilityMap ?? this.visibilityMap,
    );
  }
}
