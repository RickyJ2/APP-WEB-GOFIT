import '../Model/pegawai.dart';

class AppState {
  final Pegawai user;
  final bool authenticated;

  AppState({this.user = Pegawai.empty, this.authenticated = false});

  AppState copyWith({Pegawai? user, bool? authenticated}) {
    return AppState(
      user: user ?? this.user,
      authenticated: authenticated ?? this.authenticated,
    );
  }
}
