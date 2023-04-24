import '../Model/instruktur.dart';
import '../const.dart';

abstract class InstrukturTambahEditEvent {}

class InstrukturFormChanged extends InstrukturTambahEditEvent {
  final Instruktur instruktur;

  InstrukturFormChanged({required this.instruktur});
}

class UpdateTambahEdit extends InstrukturTambahEditEvent {
  final TambahEdit tambahEdit;
  final Instruktur instruktur;

  UpdateTambahEdit({required this.tambahEdit, required this.instruktur});
}

class PasswordVisibleChanged extends InstrukturTambahEditEvent {
  PasswordVisibleChanged();
}

class FormInputErrorChanged extends InstrukturTambahEditEvent {
  final Instruktur instrukturError;

  FormInputErrorChanged({required this.instrukturError});
}

class InstrukturTambahEditSubmitted extends InstrukturTambahEditEvent {}
