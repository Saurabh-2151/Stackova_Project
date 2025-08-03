import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class LoadPortfolio extends PortfolioEvent {
  const LoadPortfolio();
}

class SelectCategory extends PortfolioEvent {
  final String category;

  const SelectCategory(this.category);

  @override
  List<Object> get props => [category];
}

class PortfolioVisibilityChanged extends PortfolioEvent {
  final bool isVisible;

  const PortfolioVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}
