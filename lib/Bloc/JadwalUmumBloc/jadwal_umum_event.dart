abstract class JadwalUmumEvent {}

class JadwalUmumDataFetched extends JadwalUmumEvent {}

class JadwalUmumDeleteDataRequested extends JadwalUmumEvent {
  final int id;
  JadwalUmumDeleteDataRequested({required this.id});
}
