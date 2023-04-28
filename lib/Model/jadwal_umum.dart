import 'package:equatable/equatable.dart';
import 'instruktur.dart';
import 'kelas.dart';

class JadwalUmum extends Equatable {
  final String id;
  final Kelas kelas;
  final Instruktur instruktur;
  final String hari;
  final String jamMulai;

  JadwalUmum copyWith({
    String? id,
    Kelas? kelas,
    Instruktur? instruktur,
    String? hari,
    String? jamMulai,
  }) {
    return JadwalUmum(
      id: id ?? this.id,
      kelas: kelas ?? this.kelas,
      instruktur: instruktur ?? this.instruktur,
      hari: hari ?? this.hari,
      jamMulai: jamMulai ?? this.jamMulai,
    );
  }

  const JadwalUmum({
    this.id = '',
    this.kelas = const Kelas(),
    this.instruktur = const Instruktur(),
    this.hari = '',
    this.jamMulai = '',
  });

  factory JadwalUmum.createJadwalUmum(Map<String, dynamic> object) {
    return JadwalUmum(
      id: object['id'].toString(),
      kelas: Kelas(
          id: object['kelas_id'].toString(),
          nama: object['nama_kelas'].toString(),
          harga: object['harga_kelas'].toString()),
      instruktur: Instruktur(
        id: object['instruktur_id'].toString(),
        nama: object['nama_instruktur'].toString(),
        alamat: object['alamat_instruktur'].toString(),
        tglLahir: object['tgl_lahir_instruktur'].toString(),
        noTelp: object['no_telp_instruktur'].toString(),
        username: object['username_instruktur'].toString(),
      ),
      hari: object['hari'].toString(),
      jamMulai: object['jam_mulai'].toString(),
    );
  }

  static const empty = JadwalUmum(
    id: '',
    kelas: Kelas.empty,
    instruktur: Instruktur.empty,
    hari: '',
    jamMulai: '',
  );

  bool get isEmpty => this == JadwalUmum.empty;
  bool get isNoEmpty => this != JadwalUmum.empty;

  @override
  List<Object> get props => [
        id,
        kelas,
        instruktur,
        hari,
        jamMulai,
      ];
}
