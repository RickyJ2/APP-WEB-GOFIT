import '../../../Model/jadwal_umum.dart';
import '../../../const.dart';

abstract class JadwalUmumTambahEditEvent {}

class JadwalUmumFormChanged extends JadwalUmumTambahEditEvent {
  final JadwalUmum jadwalUmum;

  JadwalUmumFormChanged({required this.jadwalUmum});
}

class JadwalUmumUpdateTambahEdit extends JadwalUmumTambahEditEvent {
  final TambahEdit tambahEdit;
  final JadwalUmum jadwalUmum;

  JadwalUmumUpdateTambahEdit(
      {required this.tambahEdit, required this.jadwalUmum});
}

class JadwalUmumFormInputErrorChanged extends JadwalUmumTambahEditEvent {
  final JadwalUmum jadwalUmumError;

  JadwalUmumFormInputErrorChanged({required this.jadwalUmumError});
}

class JadwalUmumTambahEditSubmitted extends JadwalUmumTambahEditEvent {}
