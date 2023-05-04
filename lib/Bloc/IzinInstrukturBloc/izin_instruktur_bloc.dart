import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/IzinInstrukturBloc/izin_instruktur_state.dart';
import 'package:web_gofit/Repository/izin_instruktur_repository.dart';

import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';
import 'izin_instruktur_event.dart';

class IzinInstrukturBloc
    extends Bloc<IzinInstrukturEvent, IzinInstrukturState> {
  final IzinInstrukturRepository izinInstrukturRepository;

  IzinInstrukturBloc({required this.izinInstrukturRepository})
      : super(IzinInstrukturState()) {
    on<IzinInstrukturDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<IzinInstrukturConfirmedDataRequested>(
        (event, emit) => _onConfirmedDataRequested(event, emit));
    on<IzinInstrukturToogleChanged>(
        (event, emit) => _onToogleChanged(event, emit));
  }

  void _onDataFetched(IzinInstrukturDataFetched event,
      Emitter<IzinInstrukturState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: PageFetchedDataLoading(),
      confirmedFormSubmissionState: const InitialFormState(),
    ));
    try {
      final izinInstrukturList = await izinInstrukturRepository.get();
      emit(state.copyWith(
        izinInstrukturList: izinInstrukturList,
        pageFetchedDataState: PageFetchedDataSuccess(izinInstrukturList),
      ));
      if (state.toogleState[0]) {
        emit(state.copyWith(
          izinInstrukturListDisplay: state.izinInstrukturList,
        ));
      } else {
        emit(state.copyWith(
          izinInstrukturListDisplay: state.izinInstrukturList
              .where((element) => element.isConfirmed == false)
              .toList(),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.toString()),
      ));
    }
  }

  void _onConfirmedDataRequested(IzinInstrukturConfirmedDataRequested event,
      Emitter<IzinInstrukturState> emit) async {
    emit(state.copyWith(confirmedFormSubmissionState: FormSubmitting()));
    try {
      await izinInstrukturRepository.confirmed(event.id);
      emit(state.copyWith(confirmedFormSubmissionState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          confirmedFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  void _onToogleChanged(
      IzinInstrukturToogleChanged event, Emitter<IzinInstrukturState> emit) {
    emit(state.copyWith(
        confirmedFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState()));
    if (event.toogleState == 0) {
      emit(state.copyWith(toogleState: [true, false]));
    } else {
      emit(state.copyWith(toogleState: [false, true]));
    }
    add(IzinInstrukturDataFetched());
  }
}
