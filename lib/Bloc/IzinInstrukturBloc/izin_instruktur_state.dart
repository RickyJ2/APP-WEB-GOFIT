import 'package:web_gofit/Model/izin_instruktur.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../StateBlocTemplate/page_fetched_data_state.dart';

class IzinInstrukturState {
  final List<IzinInstruktur> izinInstrukturList;
  final List<IzinInstruktur> izinInstrukturListDisplay;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState confirmedFormSubmissionState;
  final List<bool> toogleState;

  IzinInstrukturState({
    this.izinInstrukturList = const [],
    this.izinInstrukturListDisplay = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.confirmedFormSubmissionState = const InitialFormState(),
    this.toogleState = const [true, false],
  });

  IzinInstrukturState copyWith({
    List<IzinInstruktur>? izinInstrukturList,
    List<IzinInstruktur>? izinInstrukturListDisplay,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? confirmedFormSubmissionState,
    List<bool>? toogleState,
  }) {
    return IzinInstrukturState(
      izinInstrukturList: izinInstrukturList ?? this.izinInstrukturList,
      izinInstrukturListDisplay:
          izinInstrukturListDisplay ?? this.izinInstrukturListDisplay,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      confirmedFormSubmissionState:
          confirmedFormSubmissionState ?? this.confirmedFormSubmissionState,
      toogleState: toogleState ?? this.toogleState,
    );
  }
}
