import 'package:equatable/equatable.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object> get props => [];
}

class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

class PortfolioLoading extends PortfolioState {
  const PortfolioLoading();
}

class PortfolioLoaded extends PortfolioState {
  final List<String> categories;
  final String selectedCategory;
  final bool isVisible;

  const PortfolioLoaded({
    required this.categories,
    required this.selectedCategory,
    required this.isVisible,
  });

  @override
  List<Object> get props => [categories, selectedCategory, isVisible];

  PortfolioLoaded copyWith({
    List<String>? categories,
    String? selectedCategory,
    bool? isVisible,
  }) {
    return PortfolioLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object> get props => [message];
}
