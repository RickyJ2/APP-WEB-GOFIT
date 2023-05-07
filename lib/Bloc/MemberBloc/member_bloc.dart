import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/member.dart';
import '../../Repository/instruktur_repository.dart';
import '../../Repository/member_repository.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';
import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository memberRepository;
  final InstrukturRepository instrukturRepository;

  MemberBloc(
      {required this.memberRepository, required this.instrukturRepository})
      : super(MemberState()) {
    on<MemberDataFetched>((event, emit) => _onDataFetched(event, emit));
    on<MemberFindDataRequested>(
        (event, emit) => _onFindDataRequested(event, emit));
    on<MemberDeleteDataRequested>(
        (event, emit) => _onDeleteDataRequested(event, emit));
    on<MemberResetPasswordRequested>(
        (event, emit) => _onResetPasswordRequested(event, emit));
    on<MemberResetDataMemberRequested>(
        (event, emit) => _onResetDataMemberRequested(event, emit));
    on<InstrukturResetDataInstrukturRequested>(
        (event, emit) => _onResetDataInstrukturRequested(event, emit));
    on<MemberToogleChanged>((event, emit) => _onToogleChanged(event, emit));
  }

  void _onDataFetched(
      MemberDataFetched event, Emitter<MemberState> emit) async {
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        deleteFormSubmissionState: const InitialFormState(),
        resetPasswordFormSubmissionState: const InitialFormState(),
        resetDataMemberState: const InitialFormState(),
        resetDataInstrukturState: const InitialFormState()));
    try {
      List<Member> memberList = [];
      if (state.toogleState[0]) {
        memberList = await memberRepository.get();
      } else if (state.toogleState[1]) {
        memberList = await memberRepository.getMembershipExpired();
      } else {
        memberList = await memberRepository.getDepositKelasExpired();
      }
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
    emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataLoading(),
        deleteFormSubmissionState: const InitialFormState(),
        resetPasswordFormSubmissionState: const InitialFormState(),
        resetDataMemberState: const InitialFormState(),
        resetDataInstrukturState: const InitialFormState()));
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
    emit(state.copyWith(
        deleteFormSubmissionState: FormSubmitting(),
        resetPasswordFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        resetDataMemberState: const InitialFormState(),
        resetDataInstrukturState: const InitialFormState()));
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
    emit(state.copyWith(
        resetPasswordFormSubmissionState: FormSubmitting(),
        deleteFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        resetDataMemberState: const InitialFormState(),
        resetDataInstrukturState: const InitialFormState()));
    try {
      await memberRepository.resetPassword(event.id);
      emit(state.copyWith(
          resetPasswordFormSubmissionState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          resetPasswordFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  void _onResetDataMemberRequested(
      MemberResetDataMemberRequested event, Emitter<MemberState> emit) async {
    emit(state.copyWith(
        resetDataMemberState: FormSubmitting(),
        deleteFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        resetPasswordFormSubmissionState: const InitialFormState(),
        resetDataInstrukturState: const InitialFormState()));
    try {
      await memberRepository.resetMemberData();
      emit(state.copyWith(resetDataMemberState: SubmissionSuccess()));
    } catch (e) {
      emit(
          state.copyWith(resetDataMemberState: SubmissionFailed(e.toString())));
    }
  }

  void _onResetDataInstrukturRequested(
      InstrukturResetDataInstrukturRequested event,
      Emitter<MemberState> emit) async {
    emit(state.copyWith(
        resetDataInstrukturState: FormSubmitting(),
        resetDataMemberState: const InitialFormState(),
        deleteFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        resetPasswordFormSubmissionState: const InitialFormState()));
    try {
      await instrukturRepository.resetDataTerlambatInstruktur();
      emit(state.copyWith(resetDataInstrukturState: SubmissionSuccess()));
    } catch (e) {
      emit(state.copyWith(
          resetDataInstrukturState: SubmissionFailed(e.toString())));
    }
  }

  void _onToogleChanged(MemberToogleChanged event, Emitter<MemberState> emit) {
    emit(state.copyWith(
        deleteFormSubmissionState: const InitialFormState(),
        pageFetchedDataState: const InitialPageFetchedDataState(),
        resetPasswordFormSubmissionState: const InitialFormState(),
        resetDataMemberState: const InitialFormState(),
        resetDataInstrukturState: const InitialFormState()));
    if (event.toogleState == 0) {
      emit(state.copyWith(toogleState: [true, false, false]));
    } else if (event.toogleState == 1) {
      emit(state.copyWith(toogleState: [false, true, false]));
    } else {
      emit(state.copyWith(toogleState: [false, false, true]));
    }
    add(MemberDataFetched());
  }
}
