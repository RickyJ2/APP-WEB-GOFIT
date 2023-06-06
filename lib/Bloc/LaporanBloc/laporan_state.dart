import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';

import '../../Model/laporan.dart';

class LaporanState {
  final FormSubmissionState formSubmissionState;
  final String laporanType;
  final String bulanForm;
  final String tahunForm;
  final String bulanError;
  final String tahunError;
  final Laporan laporan;

  LaporanState({
    this.formSubmissionState = const InitialFormState(),
    this.laporanType = 'LAPORAN PENDAPATAN BULANAN',
    this.bulanForm = '',
    this.tahunForm = '',
    this.bulanError = '',
    this.tahunError = '',
    this.laporan = const Laporan(),
  });

  LaporanState copyWith({
    FormSubmissionState? formSubmissionState,
    String? laporanType,
    String? bulanForm,
    String? tahunForm,
    String? bulanError,
    String? tahunError,
    Laporan? laporan,
  }) {
    return LaporanState(
      formSubmissionState: formSubmissionState ?? this.formSubmissionState,
      laporanType: laporanType ?? this.laporanType,
      bulanForm: bulanForm ?? this.bulanForm,
      tahunForm: tahunForm ?? this.tahunForm,
      bulanError: bulanError ?? this.bulanError,
      tahunError: tahunError ?? this.tahunError,
      laporan: laporan ?? this.laporan,
    );
  }
}
