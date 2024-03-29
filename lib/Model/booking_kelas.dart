import 'package:equatable/equatable.dart';

import 'instruktur.dart';
import 'jadwal_harian.dart';
import 'jadwal_umum.dart';
import 'kelas.dart';
import 'member.dart';

class BookingKelas extends Equatable {
  final String id;
  final String noStruk;
  final Member member;
  final JadwalHarian jadwalHarian;
  final String jenisPembayaran;
  final String sisaDeposit;
  final String masaBerlakuDeposit;
  final bool isCanceled;
  final String presentAt;
  final String createdAt;

  BookingKelas copyWith({
    String? id,
    String? noStruk,
    Member? member,
    JadwalHarian? jadwalHarian,
    String? jenisPembayaran,
    String? sisaDeposit,
    String? masaBerlakuDeposit,
    bool? isCanceled,
    String? presentAt,
    String? createdAt,
  }) {
    return BookingKelas(
      id: id ?? this.id,
      noStruk: noStruk ?? this.noStruk,
      member: member ?? this.member,
      jadwalHarian: jadwalHarian ?? this.jadwalHarian,
      jenisPembayaran: jenisPembayaran ?? this.jenisPembayaran,
      sisaDeposit: sisaDeposit ?? this.sisaDeposit,
      masaBerlakuDeposit: masaBerlakuDeposit ?? this.masaBerlakuDeposit,
      isCanceled: isCanceled ?? this.isCanceled,
      presentAt: presentAt ?? this.presentAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  const BookingKelas({
    this.id = '',
    this.noStruk = '',
    this.member = const Member(),
    this.jadwalHarian = const JadwalHarian(),
    this.jenisPembayaran = '',
    this.sisaDeposit = '',
    this.masaBerlakuDeposit = '',
    this.presentAt = '',
    this.isCanceled = false,
    this.createdAt = '',
  });

  factory BookingKelas.createBookingKelas(Map<String, dynamic> object) {
    return BookingKelas(
      id: object['id'].toString(),
      noStruk: object['no_nota'].toString() == 'null'
          ? ''
          : object['no_nota'].toString(),
      member: Member(
        id: object['member_id'].toString(),
        nama: object['nama_member'].toString(),
      ),
      jadwalHarian: JadwalHarian(
        id: object['jadwal_harian_id'].toString(),
        tanggal: object['tanggal'].toString(),
        status: object['jenis_status'],
        instrukturPenganti: object['instruktur_penganti'],
        jadwalUmum: JadwalUmum(
          hari: object['hari'].toString(),
          jamMulai: object['jam_mulai'].toString(),
          instruktur: Instruktur(
            nama: object['nama_instruktur'].toString(),
          ),
          kelas: Kelas(
            nama: object['nama_kelas'].toString(),
            harga: object['harga_kelas'].toString(),
          ),
        ),
      ),
      jenisPembayaran: (object['jenis_pembayaran'] ?? '').toString(),
      sisaDeposit: (object['sisa_deposit'] ?? '').toString(),
      masaBerlakuDeposit: (object['masa_berlaku_deposit'] ?? '').toString(),
      presentAt: object['present_at'].toString() == 'null'
          ? ''
          : object['present_at'].toString(),
      isCanceled: object['is_cancelled'].toString() == '1' ? true : false,
      createdAt: object['created_at'].toString(),
    );
  }

  static const empty = BookingKelas();

  bool get isEmpty => this == BookingKelas.empty;
  bool get isNotEmpty => this != BookingKelas.empty;

  @override
  List<Object?> get props => [
        id,
        noStruk,
        member,
        jadwalHarian,
        jenisPembayaran,
        sisaDeposit,
        masaBerlakuDeposit,
        presentAt,
        isCanceled,
        createdAt,
      ];
}
