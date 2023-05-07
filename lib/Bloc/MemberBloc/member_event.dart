abstract class MemberEvent {}

class MemberDataFetched extends MemberEvent {}

class MemberFindDataRequested extends MemberEvent {
  final String data;
  MemberFindDataRequested({required this.data});
}

class MemberDeleteDataRequested extends MemberEvent {
  final String id;
  MemberDeleteDataRequested({required this.id});
}

class MemberResetPasswordRequested extends MemberEvent {
  final String id;
  MemberResetPasswordRequested({required this.id});
}

class MemberResetDataMemberRequested extends MemberEvent {}

class MemberToogleChanged extends MemberEvent {
  final int toogleState;
  MemberToogleChanged({required this.toogleState});
}

class InstrukturResetDataInstrukturRequested extends MemberEvent {}
