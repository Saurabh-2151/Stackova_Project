import 'package:equatable/equatable.dart';
import '../../data/service_data.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesState {
  final List<Service> services;
  final bool isVisible;
  final String? selectedServiceId;

  const ServicesLoaded({
    required this.services,
    required this.isVisible,
    this.selectedServiceId,
  });

  @override
  List<Object> get props => [services, isVisible, selectedServiceId ?? ''];

  ServicesLoaded copyWith({
    List<Service>? services,
    bool? isVisible,
    String? selectedServiceId,
  }) {
    return ServicesLoaded(
      services: services ?? this.services,
      isVisible: isVisible ?? this.isVisible,
      selectedServiceId: selectedServiceId ?? this.selectedServiceId,
    );
  }
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object> get props => [message];
}
