import 'package:equatable/equatable.dart';

class LaporanKinerjaInstruktur extends Equatable {
  final String namaInstruktur;
  final String jumlahHadir;
  final String jumlahLibur;
  final String totalWaktuTerlambat;

  LaporanKinerjaInstruktur copyWith({
    String? namaInstruktur,
    String? jumlahHadir,
    String? jumlahLibur,
    String? totalWaktuTerlambat,
  }) {
    return LaporanKinerjaInstruktur(
      namaInstruktur: namaInstruktur ?? this.namaInstruktur,
      jumlahHadir: jumlahHadir ?? this.jumlahHadir,
      jumlahLibur: jumlahLibur ?? this.jumlahLibur,
      totalWaktuTerlambat: totalWaktuTerlambat ?? this.totalWaktuTerlambat,
    );
  }

  const LaporanKinerjaInstruktur({
    this.namaInstruktur = '',
    this.jumlahHadir = '',
    this.jumlahLibur = '',
    this.totalWaktuTerlambat = '',
  });

  factory LaporanKinerjaInstruktur.createLaporanKinerjaInstruktur(
      Map<String, dynamic> object) {
    return LaporanKinerjaInstruktur(
      namaInstruktur: object['nama_instruktur'].toString(),
      jumlahHadir: object['jumlah_hadir'].toString(),
      jumlahLibur: object['jumlah_libur'].toString(),
      totalWaktuTerlambat: object['total_waktu_terlambat'].toString(),
    );
  }

  static const empty = LaporanKinerjaInstruktur(
    namaInstruktur: '',
    jumlahHadir: '',
    jumlahLibur: '',
    totalWaktuTerlambat: '',
  );

  bool get isEmpty => this == LaporanKinerjaInstruktur.empty;
  bool get isNoEmpty => this != LaporanKinerjaInstruktur.empty;

  @override
  List<Object?> get props =>
      [namaInstruktur, jumlahHadir, jumlahLibur, totalWaktuTerlambat];
}
