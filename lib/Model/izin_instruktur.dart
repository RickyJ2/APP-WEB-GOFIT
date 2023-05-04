import 'package:equatable/equatable.dart';

import 'instruktur.dart';
import 'jadwal_umum.dart';
import 'kelas.dart';

class IzinInstruktur extends Equatable {
  final String id;
  final Kelas kelas;
  final Instruktur instrukturPengaju;
  final Instruktur instrukturPenganti;
  final JadwalUmum jadwalUmum;
  final String tanggalIzin;
  final bool isConfirmed;
  final String tanggalMengajukan;
  final String keterangan;

  IzinInstruktur copyWith({
    String? id,
    Kelas? kelas,
    Instruktur? instrukturPengaju,
    Instruktur? instrukturPenganti,
    JadwalUmum? jadwalUmum,
    String? tanggalIzin,
    bool? isConfirmed,
    String? tanggalMengajukan,
    String? keterangan,
  }) {
    return IzinInstruktur(
      id: id ?? this.id,
      kelas: kelas ?? this.kelas,
      instrukturPengaju: instrukturPengaju ?? this.instrukturPengaju,
      instrukturPenganti: instrukturPenganti ?? this.instrukturPenganti,
      jadwalUmum: jadwalUmum ?? this.jadwalUmum,
      tanggalIzin: tanggalIzin ?? this.tanggalIzin,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      tanggalMengajukan: tanggalMengajukan ?? this.tanggalMengajukan,
      keterangan: keterangan ?? this.keterangan,
    );
  }

  const IzinInstruktur({
    this.id = '',
    this.kelas = Kelas.empty,
    this.instrukturPengaju = Instruktur.empty,
    this.instrukturPenganti = Instruktur.empty,
    this.jadwalUmum = JadwalUmum.empty,
    this.tanggalIzin = '',
    this.isConfirmed = false,
    this.tanggalMengajukan = '',
    this.keterangan = '',
  });

  factory IzinInstruktur.createIzinInstruktur(Map<String, dynamic> object) {
    return IzinInstruktur(
      id: object['id'].toString(),
      kelas: Kelas(nama: object['nama_kelas'].toString()),
      instrukturPengaju:
          Instruktur(nama: object['instruktur_pengaju'].toString()),
      instrukturPenganti:
          Instruktur(nama: object['instruktur_penganti'].toString()),
      jadwalUmum: JadwalUmum(
        id: object['jadwal_umum_id'].toString(),
        jamMulai: object['jam_mulai'].toString(),
      ),
      tanggalIzin: object['tanggal_izin'].toString(),
      isConfirmed: object['is_confirmed'] == 1 ? true : false,
      tanggalMengajukan: object['created_at'].toString(),
      keterangan: object['keterangan'].toString(),
    );
  }

  static const empty = IzinInstruktur(
    id: '',
    kelas: Kelas.empty,
    instrukturPengaju: Instruktur.empty,
    instrukturPenganti: Instruktur.empty,
    jadwalUmum: JadwalUmum.empty,
    tanggalIzin: '',
    isConfirmed: false,
    tanggalMengajukan: '',
    keterangan: '',
  );
  bool get isEmpty => this == IzinInstruktur.empty;
  bool get isNoEmpty => this != IzinInstruktur.empty;
  @override
  List<Object> get props => [
        id,
        kelas,
        instrukturPengaju,
        instrukturPenganti,
        jadwalUmum,
        tanggalIzin,
        isConfirmed,
        tanggalMengajukan,
        keterangan,
      ];
}
