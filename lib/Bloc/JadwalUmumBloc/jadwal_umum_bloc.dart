import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/jadwal_umum_event.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/jadwal_umum_state.dart';
import 'package:web_gofit/Repository/jadwal_umum_repository.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class JadwalUmumBloc extends Bloc<JadwalUmumEvent, JadwalUmumState> {
  final JadwalUmumRepository jadwalUmumRepository;

  JadwalUmumBloc({required this.jadwalUmumRepository})
      : super(JadwalUmumState()) {
    on<JadwalUmumDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<JadwalUmumDeleteDataRequested>(
        (event, emit) => _onDeleteDataRequested(event, emit));
  }

  void _onDataFetched(
      JadwalUmumDataFetched event, Emitter<JadwalUmumState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        deleteFormSubmissionState: const InitialFormState()));
    try {
      final jadwalUmumList = await jadwalUmumRepository.get();
      emit(state.copyWith(
          jadwalUmumList: jadwalUmumList,
          pageFetchedDataState: PageFetchedDataSuccess(jadwalUmumList)));
      emit(state.copyWith(lengthColumn: _getColumnLength()));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onDeleteDataRequested(JadwalUmumDeleteDataRequested event,
      Emitter<JadwalUmumState> emit) async {
    emit(state.copyWith(deleteFormSubmissionState: FormSubmitting()));
    try {
      await jadwalUmumRepository.delete(event.id);
      emit(state.copyWith(deleteFormSubmissionState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          deleteFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  int _getColumnLength() {
    int length = 0;
    for (var day in state.jadwalUmumList) {
      if (day.jadwalUmumList.length > length) {
        length = day.jadwalUmumList.length;
      }
    }
    return length;
  }
}
