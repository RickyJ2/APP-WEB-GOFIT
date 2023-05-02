import 'package:web_gofit/Model/informasi_umum.dart';

import '../../Model/pegawai.dart';
import '../../StateBlocTemplate/load_app_state.dart';

class AppState {
  final Pegawai user;
  final InformasiUmum informasiUmum;
  final bool authenticated;
  final int selectedIndex;
  final LoadAppState authState;
  final LoadAppState logoutState;

  AppState(
      {this.user = const Pegawai(),
      this.informasiUmum = const InformasiUmum(),
      this.authenticated = false,
      this.selectedIndex = 0,
      this.authState = const InitialAppState(),
      this.logoutState = const InitialAppState()});

  AppState copyWith(
      {Pegawai? user,
      InformasiUmum? informasiUmum,
      bool? authenticated,
      int? selectedIndex,
      LoadAppState? authState,
      LoadAppState? logoutState}) {
    return AppState(
      user: user ?? this.user,
      informasiUmum: informasiUmum ?? this.informasiUmum,
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
