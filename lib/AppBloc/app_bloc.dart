import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/AppBloc/app_event.dart';
import 'package:web_gofit/AppBloc/app_state.dart';
import 'package:web_gofit/LoginBloc/login_repository.dart';
import '../Model/pegawai.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final LoginRepository loginRepository;

  AppBloc({required this.loginRepository}) : super(AppState()) {
    on<AppOpened>((event, emit) => _onAppOpened(event, emit));
    on<AppLogined>((event, emit) => _onAppLogined(event, emit));
    on<AppLogoutRequested>((event, emit) => _onAppLogoutRequested(event, emit));
  }

  void _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    try {
      Pegawai user = await loginRepository.getUser();
      emit(state.copyWith(user: user, authenticated: true));
    } on TokenFailure catch (e) {
      emit(state.copyWith(authenticated: false));
    } on GetUserFailure catch (e) {
      emit(state.copyWith(authenticated: false));
    }
  }

  void _onAppLogined(AppLogined event, Emitter<AppState> emit) async {
    try {
      Pegawai user = await loginRepository.getUser();
      emit(state.copyWith(user: user, authenticated: true));
    } on GetUserFailure catch (e) {
      emit(state.copyWith(authenticated: false));
    }
  }

  void _onAppLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    try {
      await loginRepository.logout();
      emit(state.copyWith(user: Pegawai.empty, authenticated: false));
    } on LogOutWithFailure catch (e) {
      emit(state.copyWith(authenticated: true));
    }
  }
}
