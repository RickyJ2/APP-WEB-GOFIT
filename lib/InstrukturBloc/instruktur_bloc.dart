import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_event.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_state.dart';

import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import 'instruktur_repository.dart';

class InstrukturBloc extends Bloc<InstrukturEvent, InstrukturState> {
  final InstrukturRepository instrukturRepository;

  InstrukturBloc({required this.instrukturRepository})
      : super(InstrukturState()) {
    on<InstrukturDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<InstrukturFindDataRequested>(
        (event, emit) => _onFindDataRequested(event, emit));
    on<InstrukturDeleteDataRequested>(
        (event, emit) => _onDeleteDataRequested(event, emit));
  }
  void _onDataFetched(
      InstrukturDataFetched event, Emitter<InstrukturState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        findPageFetchedDataState: const InitialPageFetchedDataState(),
        deleteFormSubmissionState: const InitialFormState()));
    try {
      final instrukturList = await instrukturRepository.get();
      emit(state.copyWith(
          instrukturList: instrukturList,
          pageFetchedDataState: PageFetchedDataSuccess(instrukturList)));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onFindDataRequested(
      InstrukturFindDataRequested event, Emitter<InstrukturState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      final instrukturList = await instrukturRepository.find(event.data);
      emit(state.copyWith(
          instrukturList: instrukturList,
          pageFetchedDataState: PageFetchedDataSuccess(instrukturList)));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onDeleteDataRequested(InstrukturDeleteDataRequested event,
      Emitter<InstrukturState> emit) async {
    emit(state.copyWith(deleteFormSubmissionState: FormSubmitting()));
    try {
      await instrukturRepository.delete(event.id);
      emit(state.copyWith(deleteFormSubmissionState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          deleteFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
