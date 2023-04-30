import 'package:equatable/equatable.dart';

class Pegawai extends Equatable {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelp;
  final String username;
  final int jabatan;

  const Pegawai({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.tglLahir = '',
    this.noTelp = '',
    this.username = '',
    this.jabatan = 1,
  });

  factory Pegawai.createPegawai(Map<String, dynamic> object) {
    return Pegawai(
      id: object['id'].toString(),
      nama: object['nama'].toString(),
      alamat: object['alamat'].toString(),
      tglLahir: object['tgl_lahir'].toString(),
      noTelp: object['no_telp'].toString(),
      username: object['username'].toString(),
      jabatan: object['jabatan_id'].toInt(),
    );
  }

  static const empty = Pegawai(
      id: '',
      nama: '',
      alamat: '',
      tglLahir: '',
      noTelp: '',
      username: '',
      jabatan: 0);

  bool get isEmpty => this == Pegawai.empty;
  bool get isNoEmpty => this != Pegawai.empty;

  @override
  List<Object?> get props =>
      [id, nama, alamat, tglLahir, noTelp, username, jabatan];
}
