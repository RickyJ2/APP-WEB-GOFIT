import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../../Model/instruktur.dart';
import '../../../const.dart';

class InstrukturTambahEditState {
  final TambahEdit tambahEdit;
  final Instruktur instrukturForm;
  final Instruktur instrukturError;
  final bool isPasswordVisible;
  final FormSubmissionState formSubmissionState;

  InstrukturTambahEditState({
    this.tambahEdit = TambahEdit.tambah,
    this.instrukturForm = const Instruktur(),
    this.instrukturError = const Instruktur(),
    this.isPasswordVisible = false,
    this.formSubmissionState = const InitialFormState(),
  });

  InstrukturTambahEditState copyWith({
    TambahEdit? tambahEdit,
    Instruktur? instrukturForm,
    Instruktur? instrukturError,
    bool? isPasswordVisible,
    FormSubmissionState? formSubmissionState,
  }) {
    return InstrukturTambahEditState(
      tambahEdit: tambahEdit ?? this.tambahEdit,
      instrukturForm: instrukturForm ?? this.instrukturForm,
      instrukturError: instrukturError ?? this.instrukturError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
    );
  }
}
