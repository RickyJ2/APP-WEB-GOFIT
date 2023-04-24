import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_repository.dart';
import 'package:web_gofit/const.dart';

import '../../Model/instruktur.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import 'instruktur_tambah_edit_event.dart';
import 'instruktur_tambah_edit_state.dart';

class InstrukturTambahEditBloc
    extends Bloc<InstrukturTambahEditEvent, InstrukturTambahEditState> {
  final InstrukturRepository instrukturRepository;

  InstrukturTambahEditBloc({required this.instrukturRepository})
      : super(InstrukturTambahEditState()) {
    on<InstrukturUpdateTambahEdit>(
        (event, emit) => _onUpdateTambahEdit(event, emit));
    on<InstrukturFormChanged>(
        (event, emit) => _onInstrukturFormChanged(event, emit));
    on<InstrukturPasswordVisibleChanged>(
        (event, emit) => _onPasswordVisibleChanged(event, emit));
    on<InstrukturFormInputErrorChanged>(
        (event, emit) => _onFormInputErrorChanged(event, emit));
    on<InstrukturTambahEditSubmitted>(
        (event, emit) => _onInstrukturTambahEditSubmitted(event, emit));
  }

  void _onUpdateTambahEdit(InstrukturUpdateTambahEdit event,
      Emitter<InstrukturTambahEditState> emit) {
    emit(state.copyWith(
        tambahEdit: event.tambahEdit, instrukturForm: event.instruktur));
  }

  void _onPasswordVisibleChanged(InstrukturPasswordVisibleChanged event,
      Emitter<InstrukturTambahEditState> emit) {
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

  void _onFormInputErrorChanged(InstrukturFormInputErrorChanged event,
      Emitter<InstrukturTambahEditState> emit) {
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
