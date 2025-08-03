import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadServices extends ServicesEvent {
  const LoadServices();
}

class ServiceCardTapped extends ServicesEvent {
  final String serviceId;

  const ServiceCardTapped(this.serviceId);

  @override
  List<Object> get props => [serviceId];
}

class ServicesVisibilityChanged extends ServicesEvent {
  final bool isVisible;

  const ServicesVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}
