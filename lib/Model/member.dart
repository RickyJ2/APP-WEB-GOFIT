import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String nama;
  final String alamat;
  final String tglLahir;
  final String noTelp;
  final String email;
  final String? password;
  final String deactivedMembershipAt;
  final int depositReguler;
  final int depositKelasPaket;
  final String deactivedDepositKelasPaket;
  final String kelasDepositKelasPaket;

  Member copyWith({
    String? id,
    String? nama,
    String? alamat,
    String? tglLahir,
    String? noTelp,
    String? email,
    String? password,
    String? deactivedMembershipAt,
    int? depositReguler,
    int? depositKelasPaket,
    String? deactivedDepositKelasPaket,
    String? kelasDepositKelasPaket,
  }) {
    return Member(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      tglLahir: tglLahir ?? this.tglLahir,
      noTelp: noTelp ?? this.noTelp,
      email: email ?? this.email,
      password: password ?? this.password,
      deactivedMembershipAt:
          deactivedMembershipAt ?? this.deactivedMembershipAt,
      depositReguler: depositReguler ?? this.depositReguler,
      depositKelasPaket: depositKelasPaket ?? this.depositKelasPaket,
      deactivedDepositKelasPaket:
          deactivedDepositKelasPaket ?? this.deactivedDepositKelasPaket,
      kelasDepositKelasPaket:
          kelasDepositKelasPaket ?? this.kelasDepositKelasPaket,
    );
  }

  const Member({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.tglLahir = '',
    this.noTelp = '',
    this.email = '',
    this.password = '',
    this.deactivedMembershipAt = 'Belum Aktif',
    this.depositReguler = 0,
    this.depositKelasPaket = 0,
    this.deactivedDepositKelasPaket = 'Belum Aktif',
    this.kelasDepositKelasPaket = '-',
  });

  factory Member.createMember(Map<String, dynamic> object) {
    return Member(
      id: object['id'].toString(),
      nama: object['nama'].toString(),
      alamat: object['alamat'].toString(),
      tglLahir: object['tgl_lahir'].toString(),
      noTelp: object['no_telp'].toString(),
      email: object['email'].toString(),
      deactivedMembershipAt: object['deactived_membership_at'].toString(),
      depositReguler: object['deposit_reguler'],
      depositKelasPaket: object['deposit_kelas_paket'],
      deactivedDepositKelasPaket:
          object['deactived_deposit_kelas_paket'].toString(),
      kelasDepositKelasPaket: object['kelas_deposit_kelas_paket'].toString(),
    );
  }

  static const empty = Member(
    id: '',
    nama: '',
    alamat: '',
    tglLahir: '',
    noTelp: '',
    email: '',
    password: '',
    deactivedMembershipAt: 'Belum Aktif',
    depositReguler: 0,
    depositKelasPaket: 0,
    deactivedDepositKelasPaket: 'Belum Aktif',
    kelasDepositKelasPaket: '-',
  );

  bool get isEmpty => this == Member.empty;
  bool get isNotEmpty => this != Member.empty;

  @override
  List<Object?> get props => [
        id,
        nama,
        alamat,
        tglLahir,
        noTelp,
        email,
        password,
        deactivedMembershipAt,
        depositReguler,
        depositKelasPaket,
        deactivedDepositKelasPaket,
        kelasDepositKelasPaket,
      ];
}
