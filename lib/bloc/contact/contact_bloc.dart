import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  late AnimationController animationController;

  ContactBloc() : super(const ContactInitial()) {
    on<InitializeContact>(_onInitializeContact);
    on<ContactVisibilityChanged>(_onContactVisibilityChanged);
    on<UpdateFormField>(_onUpdateFormField);
    on<SubmitContactForm>(_onSubmitContactForm);
    on<ResetContactForm>(_onResetContactForm);
  }

  void initializeAnimationController(TickerProvider vsync) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
  }

  void _onInitializeContact(
    InitializeContact event,
    Emitter<ContactState> emit,
  ) {
    emit(const ContactLoaded(
      isVisible: false,
      formData: {
        'name': '',
        'email': '',
        'subject': '',
        'message': '',
      },
    ));
  }

  void _onContactVisibilityChanged(
    ContactVisibilityChanged event,
    Emitter<ContactState> emit,
  ) {
    if (state is ContactLoaded) {
      final currentState = state as ContactLoaded;
      emit(currentState.copyWith(isVisible: event.isVisible));
      
      if (event.isVisible) {
        animationController.forward();
      }
    }
  }

  void _onUpdateFormField(
    UpdateFormField event,
    Emitter<ContactState> emit,
  ) {
    if (state is ContactLoaded) {
      final currentState = state as ContactLoaded;
      final updatedFormData = Map<String, String>.from(currentState.formData);
      updatedFormData[event.field] = event.value;
      
      emit(currentState.copyWith(formData: updatedFormData));
    }
  }

  void _onSubmitContactForm(
    SubmitContactForm event,
    Emitter<ContactState> emit,
  ) async {
    if (state is ContactLoaded) {
      final currentState = state as ContactLoaded;
      emit(currentState.copyWith(isSubmitting: true));
      
      try {
        // Simulate form submission
        await Future.delayed(const Duration(seconds: 2));
        
        emit(currentState.copyWith(
          isSubmitting: false,
          isSubmitted: true,
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to send message. Please try again.',
        ));
      }
    }
  }

  void _onResetContactForm(
    ResetContactForm event,
    Emitter<ContactState> emit,
  ) {
    if (state is ContactLoaded) {
      final currentState = state as ContactLoaded;
      emit(currentState.copyWith(
        formData: {
          'name': '',
          'email': '',
          'subject': '',
          'message': '',
        },
        isSubmitted: false,
        errorMessage: null,
      ));
    }
  }

  @override
  Future<void> close() {
    animationController.dispose();
    return super.close();
  }
}
