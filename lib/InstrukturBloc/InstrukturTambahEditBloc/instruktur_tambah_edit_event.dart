import '../../Model/instruktur.dart';
import '../../const.dart';

abstract class InstrukturTambahEditEvent {}

class InstrukturFormChanged extends InstrukturTambahEditEvent {
  final Instruktur instruktur;

  InstrukturFormChanged({required this.instruktur});
}

class InstrukturUpdateTambahEdit extends InstrukturTambahEditEvent {
  final TambahEdit tambahEdit;
  final Instruktur instruktur;

  InstrukturUpdateTambahEdit(
      {required this.tambahEdit, required this.instruktur});
}

class InstrukturPasswordVisibleChanged extends InstrukturTambahEditEvent {
  InstrukturPasswordVisibleChanged();
}

class InstrukturFormInputErrorChanged extends InstrukturTambahEditEvent {
  final Instruktur instrukturError;

  InstrukturFormInputErrorChanged({required this.instrukturError});
}

class InstrukturTambahEditSubmitted extends InstrukturTambahEditEvent {}
