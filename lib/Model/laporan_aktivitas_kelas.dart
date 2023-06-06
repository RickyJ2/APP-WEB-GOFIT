import 'package:equatable/equatable.dart';

class LaporanAktivitasKelas extends Equatable {
  final String kelas;
  final String instruktur;
  final String jumlahPeserta;
  final String jumlahLibur;

  LaporanAktivitasKelas copyWith({
    String? kelas,
    String? instruktur,
    String? jumlahPeserta,
    String? jumlahLibur,
  }) {
    return LaporanAktivitasKelas(
      kelas: kelas ?? this.kelas,
      instruktur: instruktur ?? this.instruktur,
      jumlahPeserta: jumlahPeserta ?? this.jumlahPeserta,
      jumlahLibur: jumlahLibur ?? this.jumlahLibur,
    );
  }

  const LaporanAktivitasKelas({
    this.kelas = '',
    this.instruktur = '',
    this.jumlahPeserta = '',
    this.jumlahLibur = '',
  });

  factory LaporanAktivitasKelas.createLaporanAktivitasKelas(
      Map<String, dynamic> object) {
    return LaporanAktivitasKelas(
      kelas: object['kelas'].toString(),
      instruktur: object['instruktur'].toString(),
      jumlahPeserta: object['jumlah_peserta'].toString(),
      jumlahLibur: object['jumlah_libur'].toString(),
    );
  }

  static const empty = LaporanAktivitasKelas(
    kelas: '',
    instruktur: '',
    jumlahPeserta: '',
    jumlahLibur: '',
  );

  bool get isEmpty => this == LaporanAktivitasKelas.empty;
  bool get isNoEmpty => this != LaporanAktivitasKelas.empty;

  @override
  List<Object?> get props => [kelas, instruktur, jumlahPeserta, jumlahLibur];
}
