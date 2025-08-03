import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class ScrollPositionChanged extends NavigationEvent {
  final double scrollOffset;

  const ScrollPositionChanged(this.scrollOffset);

  @override
  List<Object> get props => [scrollOffset];
}

class NavigateToSection extends NavigationEvent {
  final double targetOffset;

  const NavigateToSection(this.targetOffset);

  @override
  List<Object> get props => [targetOffset];
}

class ToggleMobileMenu extends NavigationEvent {
  const ToggleMobileMenu();
}
