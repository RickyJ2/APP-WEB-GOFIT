abstract class IzinInstrukturEvent {}

class IzinInstrukturDataFetched extends IzinInstrukturEvent {}

class IzinInstrukturConfirmedDataRequested extends IzinInstrukturEvent {
  final String id;
  IzinInstrukturConfirmedDataRequested({required this.id});
}

class IzinInstrukturToogleChanged extends IzinInstrukturEvent {
  final int toogleState;
  IzinInstrukturToogleChanged({required this.toogleState});
}
