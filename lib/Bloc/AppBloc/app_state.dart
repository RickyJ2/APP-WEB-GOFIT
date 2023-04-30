import '../../Model/pegawai.dart';

class AppState {
  final Pegawai user;
  final bool authenticated;
  final int selectedIndex;

  AppState(
      {this.user = const Pegawai(),
      this.authenticated = false,
      this.selectedIndex = 0});

  AppState copyWith({Pegawai? user, bool? authenticated, int? selectedIndex}) {
    return AppState(
      user: user ?? this.user,
      authenticated: authenticated ?? this.authenticated,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  AppState reset() {
    return AppState();
  }
}
