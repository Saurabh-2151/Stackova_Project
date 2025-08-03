import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {
  const NavigationInitial();
}

class NavigationScrolled extends NavigationState {
  final bool isScrolled;
  final double scrollOffset;

  const NavigationScrolled({
    required this.isScrolled,
    required this.scrollOffset,
  });

  @override
  List<Object> get props => [isScrolled, scrollOffset];
}

class NavigationMobileMenuToggled extends NavigationState {
  final bool isMenuOpen;
  final bool isScrolled;
  final double scrollOffset;

  const NavigationMobileMenuToggled({
    required this.isMenuOpen,
    required this.isScrolled,
    required this.scrollOffset,
  });

  @override
  List<Object> get props => [isMenuOpen, isScrolled, scrollOffset];
}
