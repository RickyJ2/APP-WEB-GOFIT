import 'package:web_gofit/Model/jadwal_harian_formated_list.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class JadwalHarianState {
  final List<JadwalHarianFormatedList> jadwalHarianList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState liburUpdateState;
  final PageFetchedDataState findPageFetchedDataState;
  final FormSubmissionState generateState;
  final int currentPage;
  final int lengthColumn;

  JadwalHarianState({
    this.jadwalHarianList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.liburUpdateState = const InitialFormState(),
    this.findPageFetchedDataState = const InitialPageFetchedDataState(),
    this.generateState = const InitialFormState(),
    this.currentPage = 1,
    this.lengthColumn = 0,
  });

  JadwalHarianState copyWith({
    List<JadwalHarianFormatedList>? jadwalHarianList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? liburUpdateState,
    PageFetchedDataState? findPageFetchedDataState,
    FormSubmissionState? generateState,
    int? currentPage,
    int? lengthColumn,
  }) {
    return JadwalHarianState(
      jadwalHarianList: jadwalHarianList ?? this.jadwalHarianList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      liburUpdateState: liburUpdateState ?? this.liburUpdateState,
      findPageFetchedDataState:
          findPageFetchedDataState ?? this.findPageFetchedDataState,
      generateState: generateState ?? this.generateState,
      currentPage: currentPage ?? this.currentPage,
      lengthColumn: lengthColumn ?? this.lengthColumn,
    );
  }
}
