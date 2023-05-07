import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/JadwalHarianBloc/jadwal_harian_state.dart';
import 'package:web_gofit/Repository/jadwal_harian_repository.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';
import 'jadwal_harian_event.dart';

class JadwalHarianBloc extends Bloc<JadwalHarianEvent, JadwalHarianState> {
  final JadwalHarianRepository jadwalHarianRepository;

  JadwalHarianBloc({required this.jadwalHarianRepository})
      : super(JadwalHarianState()) {
    on<JadwalHarianDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<JadwalHarianUpdateLiburRequested>(
        (event, emit) => _onUpdateLiburRequested(event, emit));
    on<JadwalHarianFindDataRequested>(
        (event, emit) => _onFindDataRequested(event, emit));
    on<JadwalHarianGenerateRequested>(
        (event, emit) => _onGenerateRequested(event, emit));
    on<CurrentPageChanged>((event, emit) => _onCurrentPageChanged(event, emit));
  }

  void _onDataFetched(
      JadwalHarianDataFetched event, Emitter<JadwalHarianState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        liburUpdateState: const InitialFormState(),
        findPageFetchedDataState: const InitialPageFetchedDataState(),
        generateState: const InitialFormState(),
        currentPage: 1));
    try {
      final jadwalHarianList = await jadwalHarianRepository.get();
      emit(state.copyWith(
          jadwalHarianList: jadwalHarianList,
          pageFetchedDataState: PageFetchedDataSuccess(jadwalHarianList),
          currentPage: 1));
      emit(state.copyWith(lengthColumn: _getColumnLength()));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
          generateState: SubmissionFailed(e.message.toString())));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onUpdateLiburRequested(JadwalHarianUpdateLiburRequested event,
      Emitter<JadwalHarianState> emit) async {
    emit(state.copyWith(
      liburUpdateState: FormSubmitting(),
      generateState: const InitialFormState(),
      findPageFetchedDataState: const InitialPageFetchedDataState(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
    ));

    try {
      await jadwalHarianRepository.updateLibur(int.parse(event.id));
      emit(state.copyWith(liburUpdateState: SubmissionSuccess()));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
          generateState: SubmissionFailed(e.message.toString())));
    } catch (e) {
      emit(state.copyWith(liburUpdateState: SubmissionFailed(e.toString())));
    }
  }

  void _onFindDataRequested(JadwalHarianFindDataRequested event,
      Emitter<JadwalHarianState> emit) async {
    emit(state.copyWith(
        findPageFetchedDataState: PageFetchedDataLoading(),
        liburUpdateState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        generateState: const InitialFormState(),
        currentPage: 1));
    try {
      final jadwalHarianList = await jadwalHarianRepository.find(event.data);
      if (jadwalHarianList.isEmpty) {
        emit(state.copyWith(
            jadwalHarianList: jadwalHarianList,
            findPageFetchedDataState: PageFetchedDataSuccess(jadwalHarianList),
            currentPage: 0,
            lengthColumn: 0));
      } else {
        emit(state.copyWith(
            jadwalHarianList: jadwalHarianList,
            findPageFetchedDataState: PageFetchedDataSuccess(jadwalHarianList),
            currentPage: 1));
        emit(state.copyWith(lengthColumn: _getColumnLength()));
      }
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
          generateState: SubmissionFailed(e.message.toString())));
    } catch (e) {
      emit(state.copyWith(
          findPageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onGenerateRequested(JadwalHarianGenerateRequested event,
      Emitter<JadwalHarianState> emit) async {
    emit(state.copyWith(
        generateState: FormSubmitting(),
        findPageFetchedDataState: const InitialPageFetchedDataState(),
        liburUpdateState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState()));
    try {
      await jadwalHarianRepository.generate();
      emit(state.copyWith(generateState: SubmissionSuccess()));
    } on FailedToLoadJadwalHarian catch (e) {
      emit(state.copyWith(
          generateState: SubmissionFailed(e.message.toString())));
    } catch (e) {
      emit(state.copyWith(generateState: SubmissionFailed(e.toString())));
    }
  }

  void _onCurrentPageChanged(
      CurrentPageChanged event, Emitter<JadwalHarianState> emit) async {
    emit(state.copyWith(
      currentPage: event.currentPage,
      findPageFetchedDataState: const InitialPageFetchedDataState(),
      liburUpdateState: const InitialFormState(),
      pageFetchedDataState: const InitialPageFetchedDataState(),
      generateState: const InitialFormState(),
    ));
  }

  int _getColumnLength() {
    int length = 0;
    for (var date in state
        .jadwalHarianList[state.currentPage - 1].jadwalHarianFormatedList) {
      if (date.jadwalHarianList.length > length) {
        length = date.jadwalHarianList.length;
      }
    }
    return length;
  }
}
