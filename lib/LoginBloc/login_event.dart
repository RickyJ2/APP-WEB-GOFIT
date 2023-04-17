abstract class LoginEvent {}

class PasswordVisibleChanged extends LoginEvent {
  PasswordVisibleChanged();
}

class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({required this.username});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginUsernameErrorChanged extends LoginEvent {
  final String usernameError;

  LoginUsernameErrorChanged({required this.usernameError});
}

class LoginPasswordErrorChanged extends LoginEvent {
  final String passwordError;

  LoginPasswordErrorChanged({required this.passwordError});
}

class LoginSubmitted extends LoginEvent {}
