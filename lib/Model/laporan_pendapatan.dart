import 'package:equatable/equatable.dart';

class LaporanPendapatan extends Equatable {
  final String bulan;
  final String aktivitas;
  final String deposit;
  final String total;

  LaporanPendapatan copyWith({
    String? bulan,
    String? aktivitas,
    String? deposit,
    String? total,
  }) {
    return LaporanPendapatan(
      bulan: bulan ?? this.bulan,
      aktivitas: aktivitas ?? this.aktivitas,
      deposit: deposit ?? this.deposit,
      total: total ?? this.total,
    );
  }

  const LaporanPendapatan({
    this.bulan = '',
    this.aktivitas = '',
    this.deposit = '',
    this.total = '',
  });

  factory LaporanPendapatan.createLaporanPendapatan(
      Map<String, dynamic> object) {
    return LaporanPendapatan(
      bulan: object['bulan'].toString(),
      aktivitas: object['aktivasi'].toString(),
      deposit: object['deposit'].toString(),
      total: object['total'].toString(),
    );
  }

  static const empty = LaporanPendapatan(
    bulan: '',
    aktivitas: '',
    deposit: '',
    total: '',
  );

  bool get isEmpty => this == LaporanPendapatan.empty;
  bool get isNoEmpty => this != LaporanPendapatan.empty;

  @override
  List<Object?> get props => [bulan, aktivitas, deposit, total];
}
