import 'package:equatable/equatable.dart';
import 'package:web_gofit/Model/jadwal_harian.dart';

class JadwalHarianFormated extends Equatable {
  final String tanggal;
  final List<JadwalHarian> jadwalHarianList;

  JadwalHarianFormated copyWith({
    String? tanggal,
    List<JadwalHarian>? jadwalHarianList,
  }) {
    return JadwalHarianFormated(
      tanggal: tanggal ?? this.tanggal,
      jadwalHarianList: jadwalHarianList ?? this.jadwalHarianList,
    );
  }

  const JadwalHarianFormated({
    this.tanggal = '',
    this.jadwalHarianList = const [],
  });

  factory JadwalHarianFormated.createJadwalHarianFormated(
      String date, dynamic object) {
    List<JadwalHarian> jadwalHarianList = [];
    object.forEach((value) =>
        jadwalHarianList.add(JadwalHarian.createJadwalHarian(value)));
    return JadwalHarianFormated(
      tanggal: date,
      jadwalHarianList: jadwalHarianList,
    );
  }

  static const empty = JadwalHarianFormated(
    tanggal: '',
    jadwalHarianList: [],
  );
  bool get isEmpty => this == JadwalHarianFormated.empty;
  bool get isNoEmpty => this != JadwalHarianFormated.empty;
  @override
  List<Object> get props => [tanggal, jadwalHarianList];
}
