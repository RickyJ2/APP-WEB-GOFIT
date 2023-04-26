import '../../../Model/member.dart';
import '../../../StateBlocTemplate/form_submission_state.dart';
import '../../../const.dart';

class MemberTambahEditState {
  final TambahEdit tambahEdit;
  final Member memberForm;
  final Member memberError;
  final bool isPasswordVisible;
  final FormSubmissionState formSubmissionState;

  MemberTambahEditState({
    this.tambahEdit = TambahEdit.tambah,
    this.memberForm = const Member(),
    this.memberError = const Member(),
    this.isPasswordVisible = false,
    this.formSubmissionState = const InitialFormState(),
  });

  MemberTambahEditState copyWith({
    TambahEdit? tambahEdit,
    Member? memberForm,
    Member? memberError,
    bool? isPasswordVisible,
    FormSubmissionState? formSubmissionState,
  }) {
    return MemberTambahEditState(
      tambahEdit: tambahEdit ?? this.tambahEdit,
      memberForm: memberForm ?? this.memberForm,
      memberError: memberError ?? this.memberError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
