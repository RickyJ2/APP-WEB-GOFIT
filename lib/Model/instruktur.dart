import 'package:equatable/equatable.dart';

class Instruktur extends Equatable {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelp;
  final String username;
  final String? password;

  Instruktur copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? tglLahir,
    String? noTelp,
    String? username,
    String? password,
  }) {
    return Instruktur(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      tglLahir: tglLahir ?? this.tglLahir,
      noTelp: noTelp ?? this.noTelp,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  const Instruktur({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.tglLahir = '',
    this.noTelp = '',
    this.username = '',
    this.password = '',
  });

  factory Instruktur.createInstruktur(Map<String, dynamic> object) {
    return Instruktur(
      id: object['id'].toString(),
      nama: object['nama'].toString(),
      alamat: object['alamat'].toString(),
      tglLahir: object['tgl_lahir'].toString(),
      noTelp: object['no_telp'].toString(),
      username: object['username'].toString(),
    );
  }

  static const empty = Instruktur(
    id: '',
    nama: '',
    alamat: '',
    tglLahir: '',
    noTelp: '',
    username: '',
    password: '',
  );

  bool get isEmpty => this == Instruktur.empty;
  bool get isNoEmpty => this != Instruktur.empty;

  @override
  List<Object?> get props => [id, nama, alamat, tglLahir, noTelp, username];
}
