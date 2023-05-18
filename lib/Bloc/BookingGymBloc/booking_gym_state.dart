import 'package:web_gofit/Model/booking_gym.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

class BookingGymState {
  final List<BookingGym> bookinGGymList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState updateFormSubmissionState;

  BookingGymState({
    this.bookinGGymList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.updateFormSubmissionState = const InitialFormState(),
  });

  BookingGymState copyWith({
    List<BookingGym>? bookinGGymList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? updateFormSubmissionState,
  }) {
    return BookingGymState(
      bookinGGymList: bookinGGymList ?? this.bookinGGymList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      updateFormSubmissionState:
          updateFormSubmissionState ?? this.updateFormSubmissionState,
    );
  }
}
