import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../Model/member.dart';
import '../../StateBlocTemplate/form_submission_state.dart';

class MemberState {
  final List<Member> memberList;
  final PageFetchedDataState pageFetchedDataState;
  final PageFetchedDataState findPageFetchedDataState;
  final FormSubmissionState deleteFormSubmissionState;
  final FormSubmissionState resetPasswordFormSubmissionState;

  MemberState({
    this.memberList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.findPageFetchedDataState = const InitialPageFetchedDataState(),
    this.deleteFormSubmissionState = const InitialFormState(),
    this.resetPasswordFormSubmissionState = const InitialFormState(),
  });

  MemberState copyWith({
    List<Member>? memberList,
    PageFetchedDataState? pageFetchedDataState,
    PageFetchedDataState? findPageFetchedDataState,
    FormSubmissionState? updateFormSubmissionState,
    FormSubmissionState? deleteFormSubmissionState,
    FormSubmissionState? resetPasswordFormSubmissionState,
  }) {
    return MemberState(
      memberList: memberList ?? this.memberList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      findPageFetchedDataState:
          findPageFetchedDataState ?? this.findPageFetchedDataState,
      deleteFormSubmissionState:
          deleteFormSubmissionState ?? this.deleteFormSubmissionState,
      resetPasswordFormSubmissionState: resetPasswordFormSubmissionState ??
          this.resetPasswordFormSubmissionState,
    );
  }
}
