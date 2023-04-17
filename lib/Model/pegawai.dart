import 'package:equatable/equatable.dart';

class Pegawai extends Equatable {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelp;
  final String username;
  final String password;
  final String jabatan;

  const Pegawai({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.tglLahir = '',
    this.noTelp = '',
    this.username = '',
    this.password = '',
    this.jabatan = '',
  });

  factory Pegawai.createPegawai(Map<String, dynamic> object) {
    return Pegawai(
      id: object['id'],
      nama: object['nama'],
      alamat: object['alamat'],
      tglLahir: object['tgl_lahir'],
      noTelp: object['no_telp'],
      username: object['username'],
      password: object['password'],
      jabatan: object['jabatan'],
    );
  }

  static const empty = Pegawai(
      id: '',
      nama: '',
      alamat: '',
      tglLahir: '',
      noTelp: '',
      username: '',
      password: '',
      jabatan: '');

  bool get isEmpty => this == Pegawai.empty;
  bool get isNoEmpty => this != Pegawai.empty;

  @override
  List<Object?> get props =>
      [id, nama, alamat, tglLahir, noTelp, username, password, jabatan];
}
