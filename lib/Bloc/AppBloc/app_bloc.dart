import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/pegawai.dart';
import '../../Repository/login_repository.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final LoginRepository loginRepository;

  AppBloc({required this.loginRepository}) : super(AppState()) {
    on<AppOpened>((event, emit) => _onAppOpened(event, emit));
    on<AppLogined>((event, emit) => _onAppLogined(event, emit));
    on<AppLogoutRequested>((event, emit) => _onAppLogoutRequested(event, emit));
    on<ChangedSelectedIndex>(
        (event, emit) => _onChangedSelectedIndex(event, emit));
  }

  void _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    try {
      Pegawai user = await loginRepository.getUser();
      emit(state.copyWith(user: user, authenticated: true));
    } on GetUserFailure {
      emit(state.copyWith(authenticated: false));
    } on TokenFailure {
      emit(state.copyWith(authenticated: false));
    } catch (e) {
      emit(state.copyWith(authenticated: false));
    }
  }

  void _onAppLogined(AppLogined event, Emitter<AppState> emit) async {
    try {
      Pegawai user = await loginRepository.getUser();
      emit(state.copyWith(user: user, authenticated: true));
    } on GetUserFailure {
      emit(state.copyWith(authenticated: false));
    }
  }

  void _onAppLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    try {
      await loginRepository.logout();
      emit(state.reset());
    } on LogOutWithFailure {
      emit(state.copyWith(authenticated: true));
    }
  }

  void _onChangedSelectedIndex(
      ChangedSelectedIndex event, Emitter<AppState> emit) async {
    emit(state.copyWith(selectedIndex: event.selectedIndex));
  }
}
