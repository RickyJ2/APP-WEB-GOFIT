import 'package:equatable/equatable.dart';
import 'package:web_gofit/Model/jadwal_umum.dart';

class JadwalUmumFormated extends Equatable {
  final String hari;
  final List<JadwalUmum> jadwalUmumList;

  JadwalUmumFormated copyWith({
    String? hari,
    List<JadwalUmum>? jadwalUmumList,
  }) {
    return JadwalUmumFormated(
      hari: hari ?? this.hari,
      jadwalUmumList: jadwalUmumList ?? this.jadwalUmumList,
    );
  }

  const JadwalUmumFormated({
    this.hari = '',
    this.jadwalUmumList = const [],
  });

  factory JadwalUmumFormated.createJadwalUmumFormated(
      String day, dynamic object) {
    List<JadwalUmum> jadwalUmumList = [];
    object.forEach(
        (value) => jadwalUmumList.add(JadwalUmum.createJadwalUmum(value)));
    return JadwalUmumFormated(
      hari: day,
      jadwalUmumList: jadwalUmumList,
    );
  }

  static const empty = JadwalUmumFormated(
    hari: '',
    jadwalUmumList: [],
  );

  bool get isEmpty => this == JadwalUmumFormated.empty;
  bool get isNoEmpty => this != JadwalUmumFormated.empty;

  @override
  List<Object> get props => [hari, jadwalUmumList];
}
