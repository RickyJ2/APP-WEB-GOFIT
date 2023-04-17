import '../model/pegawai.dart';

abstract class AppEvent {
  const AppEvent();
}

class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}

class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);

  final Pegawai user;
}
