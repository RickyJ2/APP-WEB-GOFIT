abstract class LoadAppState {
  const LoadAppState();
}

class InitialAppState extends LoadAppState {
  const InitialAppState();
}

class AppProgressing extends LoadAppState {}

class AppLoadedSuccess extends LoadAppState {}

class AppLoadedFailed extends LoadAppState {
  final String exception;

  const AppLoadedFailed(this.exception);
}
