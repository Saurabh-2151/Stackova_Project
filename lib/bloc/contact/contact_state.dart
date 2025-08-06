import 'package:equatable/equatable.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {
  const ContactInitial();
}

class ContactLoaded extends ContactState {
  final bool isVisible;
  final Map<String, String> formData;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? errorMessage;

  const ContactLoaded({
    required this.isVisible,
    required this.formData,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
    isVisible,
    formData,
    isSubmitting,
    isSubmitted,
    errorMessage ?? '',
  ];

  ContactLoaded copyWith({
    bool? isVisible,
    Map<String, String>? formData,
    bool? isSubmitting,
    bool? isSubmitted,
    String? errorMessage,
  }) {
    return ContactLoaded(
      isVisible: isVisible ?? this.isVisible,
      formData: formData ?? this.formData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ContactError extends ContactState {
  final String message;

  const ContactError(this.message);

  @override
  List<Object> get props => [message];
}
