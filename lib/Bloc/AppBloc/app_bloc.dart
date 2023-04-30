import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/pegawai.dart';
import '../../Repository/login_repository.dart';
import '../../StateBlocTemplate/load_app_state.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final LoginRepository loginRepository;

  AppBloc({required this.loginRepository}) : super(AppState()) {
    on<AppOpened>((event, emit) => _onAppOpened(event, emit));
    on<AppLogined>((event, emit) => _onAppLogined(event, emit));
    on<AppLogouted>((event, emit) => _onAppLogouted(event, emit));
    on<AppLogoutRequested>((event, emit) => _onAppLogoutRequested(event, emit));
    on<ChangedSelectedIndex>(
        (event, emit) => _onChangedSelectedIndex(event, emit));
  }

  void _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    try {
      emit(state.copyWith(authState: AppProgressing()));
      Pegawai user = await loginRepository.getUser();
      emit(state.copyWith(
          user: user, authenticated: true, authState: AppLoadedSuccess()));
    } on GetUserFailure {
      emit(state.copyWith(
          authenticated: false, authState: const AppLoadedFailed('')));
    } on TokenFailure {
      emit(state.copyWith(
          authenticated: false, authState: const AppLoadedFailed('')));
    } catch (e) {
      emit(state.copyWith(
          authenticated: false, authState: AppLoadedFailed(e.toString())));
    }
  }

  void _onAppLogined(AppLogined event, Emitter<AppState> emit) async {
    try {
      emit(state.copyWith(authState: AppProgressing()));
      Pegawai user = await loginRepository.getUser();
      emit(state.copyWith(
          user: user, authenticated: true, authState: AppLoadedSuccess()));
    } on GetUserFailure catch (e) {
      emit(state.copyWith(
          authenticated: false, authState: AppLoadedFailed(e.message)));
    }
  }

  void _onAppLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    try {
      emit(state.copyWith(logoutState: AppProgressing()));
      await loginRepository.logout();
      emit(state.copyWith(logoutState: AppLoadedSuccess()));
    } on LogOutWithFailure catch (e) {
      emit(state.copyWith(
          authenticated: true, logoutState: AppLoadedFailed(e.message)));
    }
  }

  void _onAppLogouted(AppLogouted event, Emitter<AppState> emit) async {
    emit(state.reset());
  }

  void _onChangedSelectedIndex(
      ChangedSelectedIndex event, Emitter<AppState> emit) async {
    emit(state.copyWith(selectedIndex: event.selectedIndex));
  }
}
