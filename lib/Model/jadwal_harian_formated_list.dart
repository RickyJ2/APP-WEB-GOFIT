import 'package:equatable/equatable.dart';
import 'package:web_gofit/Model/jadwal_harian_formated.dart';

class JadwalHarianFormatedList extends Equatable {
  final String startOfWeek;
  final List<JadwalHarianFormated> jadwalHarianFormatedList;

  JadwalHarianFormatedList copyWith({
    String? startOfWeek,
    List<JadwalHarianFormated>? jadwalHarianFormatedList,
  }) {
    return JadwalHarianFormatedList(
      startOfWeek: startOfWeek ?? this.startOfWeek,
      jadwalHarianFormatedList:
          jadwalHarianFormatedList ?? this.jadwalHarianFormatedList,
    );
  }

  const JadwalHarianFormatedList({
    this.startOfWeek = '',
    this.jadwalHarianFormatedList = const [],
  });

  factory JadwalHarianFormatedList.createJadwalHarianFormatedList(
      String startOfWeek, dynamic object) {
    List<JadwalHarianFormated> jadwalHarianFormatedList = [];
    object.forEach((key, value) => jadwalHarianFormatedList
        .add(JadwalHarianFormated.createJadwalHarianFormated(key, value)));
    return JadwalHarianFormatedList(
      startOfWeek: startOfWeek,
      jadwalHarianFormatedList: jadwalHarianFormatedList,
    );
  }

  static const empty = JadwalHarianFormatedList(
    startOfWeek: '',
    jadwalHarianFormatedList: [],
  );
  bool get isEmpty => this == JadwalHarianFormatedList.empty;
  bool get isNoEmpty => this != JadwalHarianFormatedList.empty;
  @override
  List<Object> get props => [startOfWeek, jadwalHarianFormatedList];
}
