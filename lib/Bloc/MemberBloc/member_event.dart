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
