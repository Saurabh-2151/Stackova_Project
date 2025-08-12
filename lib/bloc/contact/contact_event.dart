import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class InitializeContact extends ContactEvent {
  const InitializeContact();
}

class ContactVisibilityChanged extends ContactEvent {
  final bool isVisible;

  const ContactVisibilityChanged(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

class UpdateFormField extends ContactEvent {
  final String field;
  final String value;

  const UpdateFormField({
    required this.field,
    required this.value,
  });

  @override
  List<Object> get props => [field, value];
}

class SubmitContactForm extends ContactEvent {
  const SubmitContactForm(Map<String, String> map);
}

class ResetContactForm extends ContactEvent {
  const ResetContactForm();
}
