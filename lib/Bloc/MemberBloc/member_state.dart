import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../Model/member.dart';
import '../../StateBlocTemplate/form_submission_state.dart';

class MemberState {
  final List<Member> memberList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState deleteFormSubmissionState;
  final FormSubmissionState resetPasswordFormSubmissionState;
  final FormSubmissionState resetDataMemberState;
  final FormSubmissionState resetDataInstrukturState;
  final List<bool> toogleState;

  MemberState({
    this.memberList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.deleteFormSubmissionState = const InitialFormState(),
    this.resetPasswordFormSubmissionState = const InitialFormState(),
    this.resetDataMemberState = const InitialFormState(),
    this.toogleState = const [true, false, false],
    this.resetDataInstrukturState = const InitialFormState(),
  });

  MemberState copyWith({
    List<Member>? memberList,
    PageFetchedDataState? pageFetchedDataState,
    FormSubmissionState? updateFormSubmissionState,
    FormSubmissionState? deleteFormSubmissionState,
    FormSubmissionState? resetPasswordFormSubmissionState,
    FormSubmissionState? resetDataMemberState,
    List<bool>? toogleState,
    FormSubmissionState? resetDataInstrukturState,
  }) {
    return MemberState(
      memberList: memberList ?? this.memberList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      deleteFormSubmissionState:
          deleteFormSubmissionState ?? this.deleteFormSubmissionState,
      resetPasswordFormSubmissionState: resetPasswordFormSubmissionState ??
          this.resetPasswordFormSubmissionState,
      resetDataMemberState: resetDataMemberState ?? this.resetDataMemberState,
      toogleState: toogleState ?? this.toogleState,
      resetDataInstrukturState:
          resetDataInstrukturState ?? this.resetDataInstrukturState,
    );
  }
}
