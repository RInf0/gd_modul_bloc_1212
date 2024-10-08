import 'package:gd_modul_bloc_1212/bloc/form_submission_state.dart';

class LoginState{
  final bool isPasswordVisible;
  final FormSubmissionState formSubmissionState;

  LoginState({
    this.isPasswordVisible = false,
    this.formSubmissionState = const InitialFormState(),
  });

  LoginState copyWith({
    bool? isPasswordVisible,
    FormSubmissionState? formSubmissionState,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}