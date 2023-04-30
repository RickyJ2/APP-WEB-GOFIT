import 'package:equatable/equatable.dart';
import 'package:web_gofit/Model/instruktur.dart';
import 'package:web_gofit/Model/jadwal_umum.dart';

import 'kelas.dart';

class JadwalHarian extends Equatable {
  final String id;
  final JadwalUmum jadwalUmum;
  final String tanggal;
  final String status;
  final String instrukturPenganti;

  JadwalHarian copyWith({
    String? id,
    JadwalUmum? jadwalUmum,
    String? tanggal,
    String? status,
    String? instrukturPenganti,
  }) {
    return JadwalHarian(
      id: id ?? this.id,
      jadwalUmum: jadwalUmum ?? this.jadwalUmum,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
      instrukturPenganti: instrukturPenganti ?? this.instrukturPenganti,
    );
  }

  const JadwalHarian({
    this.id = '',
    this.jadwalUmum = const JadwalUmum(),
    this.tanggal = '',
    this.status = '',
    this.instrukturPenganti = '',
  });

  factory JadwalHarian.createJadwalHarian(Map<String, dynamic> object) {
    return JadwalHarian(
      id: object['id'].toString(),
      jadwalUmum: JadwalUmum(
        kelas: Kelas(
          nama: object['nama_kelas'].toString(),
        ),
        instruktur: Instruktur(
          nama: object['nama_instruktur'].toString(),
        ),
        jamMulai: object['jam_mulai'].toString(),
        hari: object['hari'].toString(),
      ),
      tanggal: object['tanggal'].toString(),
      status: object['jenis_status'],
      instrukturPenganti: object['instruktur_penganti'],
    );
  }

  static const empty = JadwalHarian(
    id: '',
    jadwalUmum: JadwalUmum.empty,
    tanggal: '',
    status: '',
    instrukturPenganti: '',
  );

  bool get isEmpty => this == JadwalHarian.empty;
  bool get isNoEmpty => this != JadwalHarian.empty;

  @override
  List<Object> get props => [
        id,
        jadwalUmum,
        tanggal,
        status,
        instrukturPenganti,
      ];
}
