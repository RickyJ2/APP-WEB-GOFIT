import 'package:web_gofit/form_submission_state.dart';

class LoginState {
  final String username;
  final String password;
  final String usernameError;
  final String passwordError;
  final bool isPasswordVisible;
  final FormSubmissionState formSubmissionState;

  LoginState({
    this.username = '',
    this.password = '',
    this.usernameError = '',
    this.passwordError = '',
    this.isPasswordVisible = false,
    this.formSubmissionState = const InitialFormState(),
  });

  LoginState copyWith({
    String? username,
    String? password,
    String? usernameError,
    String? passwordError,
    bool? isPasswordVisible,
    FormSubmissionState? formSubmissionState,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      usernameError: usernameError ?? this.usernameError,
      passwordError: passwordError ?? this.passwordError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
