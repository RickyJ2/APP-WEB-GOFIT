import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository/member_repository.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';
import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository memberRepository;

  MemberBloc({required this.memberRepository}) : super(MemberState()) {
    on<MemberDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<MemberFindDataRequested>(
        (event, emit) => _onFindDataRequested(event, emit));
    on<MemberDeleteDataRequested>(
        (event, emit) => _onDeleteDataRequested(event, emit));
    on<MemberResetPasswordRequested>(
        (event, emit) => _onResetPasswordRequested(event, emit));
  }

  void _onDataFetched(
      MemberDataFetched event, Emitter<MemberState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        findPageFetchedDataState: const InitialPageFetchedDataState(),
        deleteFormSubmissionState: const InitialFormState(),
        resetPasswordFormSubmissionState: const InitialFormState()));
    try {
      final memberList = await memberRepository.get();
      emit(state.copyWith(
          memberList: memberList,
          pageFetchedDataState: PageFetchedDataSuccess(memberList)));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onFindDataRequested(
      MemberFindDataRequested event, Emitter<MemberState> emit) async {
    emit(state.copyWith(pageFetchedDataState: PageFetchedDataLoading()));
    try {
      final memberList = await memberRepository.find(event.data);
      emit(state.copyWith(
          memberList: memberList,
          pageFetchedDataState: PageFetchedDataSuccess(memberList)));
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onDeleteDataRequested(
      MemberDeleteDataRequested event, Emitter<MemberState> emit) async {
    emit(state.copyWith(deleteFormSubmissionState: FormSubmitting()));
    try {
      await memberRepository.delete(event.id);
      emit(state.copyWith(deleteFormSubmissionState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          deleteFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  void _onResetPasswordRequested(
      MemberResetPasswordRequested event, Emitter<MemberState> emit) async {
    emit(state.copyWith(resetPasswordFormSubmissionState: FormSubmitting()));
    try {
      await memberRepository.resetPassword(event.id);
      emit(state.copyWith(
          resetPasswordFormSubmissionState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          resetPasswordFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }
}
