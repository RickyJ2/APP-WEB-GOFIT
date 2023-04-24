import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_repository.dart';
import 'package:web_gofit/const.dart';

import '../Model/instruktur.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import 'instruktur_tambah_edit_event.dart';
import 'instruktur_tambah_edit_state.dart';

class InstrukturTambahEditBloc
    extends Bloc<InstrukturTambahEditEvent, InstrukturTambahEditState> {
  final InstrukturRepository instrukturRepository;

  InstrukturTambahEditBloc({required this.instrukturRepository})
      : super(InstrukturTambahEditState()) {
    on<UpdateTambahEdit>((event, emit) => _onUpdateTambahEdit(event, emit));
    on<InstrukturFormChanged>(
        (event, emit) => _onInstrukturFormChanged(event, emit));
    on<PasswordVisibleChanged>(
        (event, emit) => _onPasswordVisibleChanged(event, emit));
    on<FormInputErrorChanged>(
        (event, emit) => _onFormInputErrorChanged(event, emit));
    on<InstrukturTambahEditSubmitted>(
        (event, emit) => _onInstrukturTambahEditSubmitted(event, emit));
  }

  void updateTglLahir(String value) {
    add(InstrukturFormChanged(
      instruktur: state.instrukturForm.copyWith(tglLahir: value),
    ));
  }

  void _onUpdateTambahEdit(
      UpdateTambahEdit event, Emitter<InstrukturTambahEditState> emit) {
    emit(state.copyWith(
        tambahEdit: event.tambahEdit, instrukturForm: event.instruktur));
  }

  void _onPasswordVisibleChanged(
      PasswordVisibleChanged event, Emitter<InstrukturTambahEditState> emit) {
    emit(state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        formSubmissionState: const InitialFormState()));
  }

  void _onInstrukturFormChanged(
      InstrukturFormChanged event, Emitter<InstrukturTambahEditState> emit) {
    emit(state.copyWith(
        instrukturForm: event.instruktur,
        formSubmissionState: const InitialFormState()));
  }

  void _onFormInputErrorChanged(
      FormInputErrorChanged event, Emitter<InstrukturTambahEditState> emit) {
    emit(state.copyWith(
        instrukturError: event.instrukturError,
        formSubmissionState: const InitialFormState()));
  }

  void _onInstrukturTambahEditSubmitted(InstrukturTambahEditSubmitted event,
      Emitter<InstrukturTambahEditState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    if (state.tambahEdit == TambahEdit.tambah) {
      try {
        emit(state.copyWith(instrukturError: const Instruktur()));
        await instrukturRepository.register(state.instrukturForm);
        emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
      } on ErrorValidatedFromInstruktur catch (e) {
        emit(state.copyWith(
            instrukturError: e.message,
            formSubmissionState: SubmissionFailed(e.toString())));
      } catch (e) {
        emit(state.copyWith(
            formSubmissionState: SubmissionFailed(e.toString())));
      }
    } else {
      try {
        emit(state.copyWith(instrukturError: const Instruktur()));
        await instrukturRepository.update(state.instrukturForm);
        emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
      } on ErrorValidatedFromInstruktur catch (e) {
        emit(state.copyWith(
            instrukturError: e.message,
            formSubmissionState: SubmissionFailed(e.toString())));
      } catch (e) {
        emit(state.copyWith(
            formSubmissionState: SubmissionFailed(e.toString())));
      }
    }
  }
}
