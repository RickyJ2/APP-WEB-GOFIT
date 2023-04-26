import '../../../Model/member.dart';
import '../../../const.dart';

abstract class MemberTambahEditEvent {}

class MemberFormChanged extends MemberTambahEditEvent {
  final Member member;

  MemberFormChanged({required this.member});
}

class MemberUpdateTambahEdit extends MemberTambahEditEvent {
  final TambahEdit tambahEdit;
  final Member member;

  MemberUpdateTambahEdit({required this.tambahEdit, required this.member});
}

class MemberPasswordVisibleChanged extends MemberTambahEditEvent {
  MemberPasswordVisibleChanged();
}

class MemberFormInputErrorChanged extends MemberTambahEditEvent {
  final Member memberError;

  MemberFormInputErrorChanged({required this.memberError});
}

class MemberTambahEditSubmitted extends MemberTambahEditEvent {}
