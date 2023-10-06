import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_modul_bloc_1212/bloc/form_submission_state.dart';
import 'package:gd_modul_bloc_1212/bloc/login_event.dart';
import 'package:gd_modul_bloc_1212/bloc/login_state.dart';
import 'package:gd_modul_bloc_1212/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository = LoginRepository();
  LoginBloc() : super(LoginState()) {
    on<IsPasswordVisibleChanged>((event, emit) => _onIsPasswordVisibleChanged(event, emit));
    on<FormSumitted>((event, emit) => _onFormSubmitted(event, emit));
  }
  void _onIsPasswordVisibleChanged(IsPasswordVisibleChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
      formSubmissionState: const InitialFormState(),
    ));
  }
  
  void _onFormSubmitted(FormSumitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formSubmissionState:  FormSubmitting()));
    try{
      await loginRepository.login(event.username, event.password);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on FailedLogin catch (e){
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.errorMessage())));
    } on String catch (e){
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e)));
    } catch (e){
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}