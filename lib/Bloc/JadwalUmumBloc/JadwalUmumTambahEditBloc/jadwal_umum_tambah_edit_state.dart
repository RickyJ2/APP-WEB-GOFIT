import 'package:flutter/material.dart';
import 'package:web_gofit/Model/jadwal_umum.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../../Model/instruktur.dart';
import '../../../Model/kelas.dart';
import '../../../StateBlocTemplate/page_fetched_data_state.dart';
import '../../../const.dart';

class JadwalUmumTambahEditState {
  final List<Instruktur> instrukturList;
  final List<Kelas> kelasList;
  final TambahEdit tambahEdit;
  final PageFetchedDataState pageFetchedDataState;
  final JadwalUmum jadwalUmumForm;
  final JadwalUmum jadwalUmumError;
  final FormSubmissionState formSubmissionState;
  final Widget jamMulaiHelperText;

  JadwalUmumTambahEditState({
    this.instrukturList = const [],
    this.kelasList = const [],
    this.tambahEdit = TambahEdit.tambah,
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.jadwalUmumForm = const JadwalUmum(),
    this.jadwalUmumError = const JadwalUmum(),
    this.formSubmissionState = const InitialFormState(),
    this.jamMulaiHelperText = const SizedBox.shrink(),
  });

  JadwalUmumTambahEditState copyWith({
    List<Instruktur>? instrukturList,
    List<Kelas>? kelasList,
    TambahEdit? tambahEdit,
    PageFetchedDataState? pageFetchedDataState,
    JadwalUmum? jadwalUmumForm,
    JadwalUmum? jadwalUmumError,
    FormSubmissionState? formSubmissionState,
    Widget? jamMulaiHelperText,
  }) {
    return JadwalUmumTambahEditState(
      instrukturList: instrukturList ?? this.instrukturList,
      kelasList: kelasList ?? this.kelasList,
      tambahEdit: tambahEdit ?? this.tambahEdit,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      jadwalUmumForm: jadwalUmumForm ?? this.jadwalUmumForm,
      jadwalUmumError: jadwalUmumError ?? this.jadwalUmumError,
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      jamMulaiHelperText: jamMulaiHelperText ?? this.jamMulaiHelperText,
    );
  }
}
