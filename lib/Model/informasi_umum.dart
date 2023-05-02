import 'package:equatable/equatable.dart';

class InformasiUmum extends Equatable {
  final String nama;
  final String alamat;
  final String deskripsi;
  final int biayaAktivasiMembership;
  final int minDepositReguler;
  final int maxDepositKelasAwal;

  InformasiUmum copyWith({
    String? nama,
    String? alamat,
    String? deskripsi,
    int? biayaAktivasiMembership,
    int? minDepositReguler,
    int? maxDepositKelasAwal,
  }) {
    return InformasiUmum(
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      deskripsi: deskripsi ?? this.deskripsi,
      biayaAktivasiMembership:
          biayaAktivasiMembership ?? this.biayaAktivasiMembership,
      minDepositReguler: minDepositReguler ?? this.minDepositReguler,
      maxDepositKelasAwal: maxDepositKelasAwal ?? this.maxDepositKelasAwal,
    );
  }

  const InformasiUmum({
    this.nama = 'Gym GoFit',
    this.alamat = 'Jl. Centralpark No. 10 Yogyakarta',
    this.deskripsi = 'Jl. Centralpark No. 10 Yogyakarta',
    this.biayaAktivasiMembership = 3000000,
    this.minDepositReguler = 500000,
    this.maxDepositKelasAwal = 0,
  });

  factory InformasiUmum.createInformasiUmum(Map<String, dynamic> object) {
    return InformasiUmum(
      nama: object['nama'].toString(),
      alamat: object['alamat'].toString(),
      deskripsi: object['deskripsi'].toString(),
      biayaAktivasiMembership:
          int.parse(object['biaya_aktivasi_membership'].toString()),
      minDepositReguler: int.parse(object['min_deposit_reguler'].toString()),
      maxDepositKelasAwal:
          int.parse(object['max_deposit_kelas_awal'].toString()),
    );
  }

  static const empty = InformasiUmum(
    nama: '',
    alamat: '',
    deskripsi: '',
    biayaAktivasiMembership: 0,
    minDepositReguler: 0,
    maxDepositKelasAwal: 0,
  );

  bool get isEmpty => this == InformasiUmum.empty;
  bool get isNotEmpty => this != InformasiUmum.empty;

  @override
  List<Object?> get props => [
        nama,
        alamat,
        deskripsi,
        biayaAktivasiMembership,
        minDepositReguler,
        maxDepositKelasAwal,
      ];
}
