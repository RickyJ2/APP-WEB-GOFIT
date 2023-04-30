import '../../Model/pegawai.dart';
import '../../StateBlocTemplate/load_app_state.dart';

class AppState {
  final Pegawai user;
  final bool authenticated;
  final int selectedIndex;
  final LoadAppState authState;
  final LoadAppState logoutState;

  AppState(
      {this.user = const Pegawai(),
      this.authenticated = false,
      this.selectedIndex = 0,
      this.authState = const InitialAppState(),
      this.logoutState = const InitialAppState()});

  AppState copyWith(
      {Pegawai? user,
      bool? authenticated,
      int? selectedIndex,
      LoadAppState? authState,
      LoadAppState? logoutState}) {
    return AppState(
      user: user ?? this.user,
      authenticated: authenticated ?? this.authenticated,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      authState: authState ?? this.authState,
      logoutState: logoutState ?? this.logoutState,
    );
  }

  AppState reset() {
    return AppState();
  }
}
