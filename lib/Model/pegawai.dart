class Pegawai {
  final String? id;
  final String? nama;
  final String? alamat;
  final String? tglLahir;
  final String? noTelp;
  final String? username;
  final String? password;
  final String? jabatan;

  Pegawai({
    this.id,
    this.nama,
    this.alamat,
    this.tglLahir,
    this.noTelp,
    this.username,
    this.password,
    this.jabatan,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      tglLahir: json['tgl_lahir'],
      noTelp: json['no_telp'],
      username: json['username'],
      password: json['password'],
      jabatan: json['jabatan'],
    );
  }
}
