import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Model/member.dart';
import '../../../Repository/member_repository.dart';
import '../../../StateBlocTemplate/form_submission_state.dart';
import '../../../const.dart';
import 'member_tambah_edit_event.dart';
import 'member_tambah_edit_state.dart';

class MemberTambahEditBloc
    extends Bloc<MemberTambahEditEvent, MemberTambahEditState> {
  final MemberRepository memberRepository;

  MemberTambahEditBloc({required this.memberRepository})
      : super(MemberTambahEditState()) {
    on<MemberUpdateTambahEdit>(
        (event, emit) => _onUpdateTambahEdit(event, emit));
    on<MemberFormChanged>((event, emit) => _onMemberFormChanged(event, emit));
    on<MemberPasswordVisibleChanged>(
        (event, emit) => _onPasswordVisibleChanged(event, emit));
    on<MemberFormInputErrorChanged>(
        (event, emit) => _onFormInputErrorChanged(event, emit));
    on<MemberTambahEditSubmitted>(
        (event, emit) => _onMemberTambahEditSubmitted(event, emit));
  }

  void _onUpdateTambahEdit(
      MemberUpdateTambahEdit event, Emitter<MemberTambahEditState> emit) {
    emit(
        state.copyWith(tambahEdit: event.tambahEdit, memberForm: event.member));
  }

  void _onPasswordVisibleChanged(
      MemberPasswordVisibleChanged event, Emitter<MemberTambahEditState> emit) {
    emit(state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        formSubmissionState: const InitialFormState()));
  }

  void _onMemberFormChanged(
      MemberFormChanged event, Emitter<MemberTambahEditState> emit) {
    emit(state.copyWith(
        memberForm: event.member,
        formSubmissionState: const InitialFormState()));
  }

  void _onFormInputErrorChanged(
      MemberFormInputErrorChanged event, Emitter<MemberTambahEditState> emit) {
    emit(state.copyWith(
        memberError: event.memberError,
        formSubmissionState: const InitialFormState()));
  }

  void _onMemberTambahEditSubmitted(MemberTambahEditSubmitted event,
      Emitter<MemberTambahEditState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    if (state.tambahEdit == TambahEdit.tambah) {
      try {
        emit(state.copyWith(memberError: const Member()));
        await memberRepository.register(state.memberForm);
        emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
      } on ErrorValidateFromMember catch (e) {
        emit(state.copyWith(
            memberError: e.member,
            formSubmissionState: SubmissionFailed(e.toString())));
      } catch (e) {
        emit(state.copyWith(
            formSubmissionState: SubmissionFailed(e.toString())));
      }
    } else if (state.tambahEdit == TambahEdit.edit) {
      try {
        emit(state.copyWith(memberError: const Member()));
        await memberRepository.update(state.memberForm);
        emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
      } on ErrorValidateFromMember catch (e) {
        emit(state.copyWith(
            memberError: e.member,
            formSubmissionState: SubmissionFailed(e.toString())));
      } catch (e) {
        emit(state.copyWith(
            formSubmissionState: SubmissionFailed(e.toString())));
      }
    }
  }
}
