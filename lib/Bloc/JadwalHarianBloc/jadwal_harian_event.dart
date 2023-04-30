abstract class JadwalHarianEvent {}

class JadwalHarianDataFetched extends JadwalHarianEvent {}

class JadwalHarianUpdateLiburRequested extends JadwalHarianEvent {
  final String id;
  JadwalHarianUpdateLiburRequested({required this.id});
}

class JadwalHarianFindDataRequested extends JadwalHarianEvent {
  final String data;
  JadwalHarianFindDataRequested({required this.data});
}

class JadwalHarianGenerateRequested extends JadwalHarianEvent {}

class CurrentPageChanged extends JadwalHarianEvent {
  final int currentPage;
  CurrentPageChanged({required this.currentPage});
}
