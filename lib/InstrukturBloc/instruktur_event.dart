abstract class InstrukturEvent {}

class InstrukturDataFetched extends InstrukturEvent {}

class InstrukturFindDataRequested extends InstrukturEvent {
  final String data;
  InstrukturFindDataRequested({required this.data});
}

class InstrukturDeleteDataRequested extends InstrukturEvent {
  final int id;
  InstrukturDeleteDataRequested({required this.id});
}
