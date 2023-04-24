import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';

import '../Model/instruktur.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';

class InstrukturState {
  final List<Instruktur> instrukturList;
  final PageFetchedDataState pageFetchedDataState;
  final PageFetchedDataState findPageFetchedDataState;
  final FormSubmissionState deleteFormSubmissionState;

  InstrukturState({
    this.instrukturList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.findPageFetchedDataState = const InitialPageFetchedDataState(),
    this.deleteFormSubmissionState = const InitialFormState(),
  });

  InstrukturState copyWith({
    List<Instruktur>? instrukturList,
    PageFetchedDataState? pageFetchedDataState,
    PageFetchedDataState? findPageFetchedDataState,
    FormSubmissionState? updateFormSubmissionState,
    FormSubmissionState? deleteFormSubmissionState,
  }) {
    return InstrukturState(
      instrukturList: instrukturList ?? this.instrukturList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      findPageFetchedDataState:
          findPageFetchedDataState ?? this.findPageFetchedDataState,
      deleteFormSubmissionState:
          deleteFormSubmissionState ?? this.deleteFormSubmissionState,
    );
  }
}
