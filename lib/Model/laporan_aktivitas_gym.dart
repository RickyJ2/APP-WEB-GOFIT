import 'package:equatable/equatable.dart';

class LaporanAktivitasGym extends Equatable {
  final String tanggal;
  final String jumlahMember;

  LaporanAktivitasGym copyWith({
    String? tanggal,
    String? jumlahMember,
  }) {
    return LaporanAktivitasGym(
      tanggal: tanggal ?? this.tanggal,
      jumlahMember: jumlahMember ?? this.jumlahMember,
    );
  }

  const LaporanAktivitasGym({
    this.tanggal = '',
    this.jumlahMember = '',
  });

  factory LaporanAktivitasGym.createLaporanAktivitasGym(
      Map<String, dynamic> object) {
    return LaporanAktivitasGym(
      tanggal: object['tanggal'].toString(),
      jumlahMember: object['jumlah_member'].toString(),
    );
  }

  static const empty = LaporanAktivitasGym(
    tanggal: '',
    jumlahMember: '',
  );

  bool get isEmpty => this == LaporanAktivitasGym.empty;
  bool get isNoEmpty => this != LaporanAktivitasGym.empty;

  @override
  List<Object?> get props => [tanggal, jumlahMember];
}
