import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/login_repository.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginState()) {
    on<LoginUsernameChanged>(
        (event, emit) => _onLoginUsernameChanged(event, emit));
    on<LoginPasswordChanged>(
        (event, emit) => _onLoginPasswordChanged(event, emit));
    on<PasswordVisibleChanged>(
        (event, emit) => _onPasswordVisibleChanged(event, emit));
    on<LoginSubmitted>((event, emit) => _onLoginSubmitted(event, emit));
  }

  void _onLoginUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        username: event.username,
        formSubmissionState: const InitialFormState()));
  }

  void _onLoginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        password: event.password,
        formSubmissionState: const InitialFormState()));
  }

  void _onPasswordVisibleChanged(
      PasswordVisibleChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        formSubmissionState: const InitialFormState()));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));

    try {
      emit(state.copyWith(usernameError: '', passwordError: ''));
      await loginRepository.login(state.username, state.password);
      emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
    } on LogInWithUsernamePasswordFailure catch (e) {
      emit(state.copyWith(
          usernameError: e.message['username'],
          passwordError: e.message['password']));
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    } on LogInWithFailure catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.message)));
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
