import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/JadwalUmumTambahEditBloc/jadwal_umum_tambah_edit_event.dart';
import 'package:web_gofit/Repository/instruktur_repository.dart';
import 'package:web_gofit/Repository/jadwal_umum_repository.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../../Model/jadwal_umum.dart';
import '../../../Repository/kelas_repository.dart';
import '../../../StateBlocTemplate/form_submission_state.dart';
import '../../../const.dart';
import 'jadwal_umum_tambah_edit_state.dart';

class JadwalUmumTambahEditBloc
    extends Bloc<JadwalUmumTambahEditEvent, JadwalUmumTambahEditState> {
  final JadwalUmumRepository jadwalUmumRepository;
  final InstrukturRepository instrukturRepository;
  final KelasRepository kelasRepository;

  JadwalUmumTambahEditBloc(
      {required this.jadwalUmumRepository,
      required this.instrukturRepository,
      required this.kelasRepository})
      : super(JadwalUmumTambahEditState()) {
    on<JadwalUmumUpdateTambahEdit>(
        (event, emit) => _onUpdateTambahEdit(event, emit));
    on<JadwalUmumJamMulaiFormChanged>(
        (event, emit) => _onJadwalUmumJamMulaiFormChanged(event, emit));
    on<JadwalUmumFormChanged>(
        (event, emit) => _onJadwalUmumFormChanged(event, emit));
    on<JadwalUmumFormInputErrorChanged>(
        (event, emit) => _onFormInputErrorChanged(event, emit));
    on<JadwalUmumTambahEditSubmitted>(
        (event, emit) => _onJadwalUmumTambahEditSubmitted(event, emit));
  }

  void _onUpdateTambahEdit(JadwalUmumUpdateTambahEdit event,
      Emitter<JadwalUmumTambahEditState> emit) async {
    emit(state.copyWith(
        tambahEdit: event.tambahEdit,
        jadwalUmumForm: event.jadwalUmum,
        pageFetchedDataState: PageFetchedDataLoading()));
    try {
      final instrukturList = await instrukturRepository.get();
      final kelasList = await kelasRepository.get();
      emit(state.copyWith(
        instrukturList: instrukturList,
        kelasList: kelasList,
        pageFetchedDataState: const PageFetchedDataSuccess([]),
      ));
      if (state.tambahEdit == TambahEdit.tambah) {
        emit(state.copyWith(
            jadwalUmumForm: state.jadwalUmumForm.copyWith(
                instruktur: instrukturList.first,
                kelas: kelasList.first,
                hari: day.first)));
      }
    } catch (e) {
      emit(state.copyWith(
          pageFetchedDataState: PageFetchedDataFailed(e.toString())));
    }
  }

  void _onJadwalUmumFormChanged(
      JadwalUmumFormChanged event, Emitter<JadwalUmumTambahEditState> emit) {
    emit(state.copyWith(
        jadwalUmumForm: event.jadwalUmum,
        formSubmissionState: const InitialFormState()));
  }

  void _onJadwalUmumJamMulaiFormChanged(JadwalUmumJamMulaiFormChanged event,
      Emitter<JadwalUmumTambahEditState> emit) {
    emit(state.copyWith(
        jadwalUmumForm: state.jadwalUmumForm.copyWith(jamMulai: event.jamMulai),
        formSubmissionState: const InitialFormState()));
    try {
      int hour = int.parse(state.jadwalUmumForm.jamMulai.split(':')[0]) + 1;
      int minute = int.parse(state.jadwalUmumForm.jamMulai.split(':')[1]);
      emit(
        state.copyWith(
          jamMulaiHelperText: Text(
            'Kelas diperkirakan akan selesai pada pukul ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
            style: TextStyle(
                fontSize: 14, color: accentColor, fontFamily: 'roboto'),
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          jamMulaiHelperText: Text(
            'Jam mulai harus dalam format hh:mm',
            style: TextStyle(
              fontSize: 14,
              color: errorTextColor,
              fontFamily: 'roboto',
            ),
          ),
        ),
      );
    }
  }

  void _onFormInputErrorChanged(JadwalUmumFormInputErrorChanged event,
      Emitter<JadwalUmumTambahEditState> emit) {
    emit(
      state.copyWith(
        jadwalUmumError: event.jadwalUmumError,
        formSubmissionState: const InitialFormState(),
      ),
    );
  }

  void _onJadwalUmumTambahEditSubmitted(JadwalUmumTambahEditSubmitted event,
      Emitter<JadwalUmumTambahEditState> emit) async {
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    if (state.tambahEdit == TambahEdit.tambah) {
      try {
        emit(state.copyWith(jadwalUmumError: const JadwalUmum()));
        await jadwalUmumRepository.add(state.jadwalUmumForm);
        emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
      } on ErrorValidatedFromJadwalUmum catch (e) {
        emit(state.copyWith(
            jadwalUmumError: e.message,
            formSubmissionState: SubmissionFailed(e.toString())));
      } catch (e) {
        emit(state.copyWith(
            formSubmissionState: SubmissionFailed(e.toString())));
      }
    } else {
      try {
        emit(state.copyWith(jadwalUmumError: const JadwalUmum()));
        await jadwalUmumRepository.update(state.jadwalUmumForm);
        emit(state.copyWith(formSubmissionState: SubmissionSuccess()));
      } on ErrorValidatedFromJadwalUmum catch (e) {
        emit(state.copyWith(
            jadwalUmumError: e.message,
            formSubmissionState: SubmissionFailed(e.toString())));
      } catch (e) {
        emit(state.copyWith(
            formSubmissionState: SubmissionFailed(e.toString())));
      }
    }
  }
}
