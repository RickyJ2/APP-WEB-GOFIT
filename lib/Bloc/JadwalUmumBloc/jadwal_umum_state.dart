import 'package:web_gofit/Model/jadwal_umum_formated.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class JadwalUmumState {
  final List<JadwalUmumFormated> jadwalUmumList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState deleteFormSubmissionState;
  final int lengthColumn;

  JadwalUmumState({
    this.jadwalUmumList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.deleteFormSubmissionState = const InitialFormState(),
    this.lengthColumn = 0,
  });

  JadwalUmumState copyWith({
    List<JadwalUmumFormated>? jadwalUmumList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? deleteFormSubmissionState,
    int? lengthColumn,
  }) {
    return JadwalUmumState(
      jadwalUmumList: jadwalUmumList ?? this.jadwalUmumList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      deleteFormSubmissionState:
          deleteFormSubmissionState ?? this.deleteFormSubmissionState,
      lengthColumn: lengthColumn ?? this.lengthColumn,
    );
  }
}
