abstract class InstrukturEvent {}

class DataFetched extends InstrukturEvent {}

class FindDataRequested extends InstrukturEvent {
  final String data;
  FindDataRequested({required this.data});
}

class DeleteDataRequested extends InstrukturEvent {
  final int id;
  DeleteDataRequested({required this.id});
}
