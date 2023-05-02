import 'package:equatable/equatable.dart';
import 'package:web_gofit/Model/pegawai.dart';
import 'package:web_gofit/Model/promo.dart';

import 'kelas.dart';
import 'member.dart';

class Transaksi extends Equatable {
  final String noNota;
  final Pegawai kasir;
  final Member member;
  final String jenisTransaksi;
  final String tanggalTransaksi;
  final String nominalDeposit;
  final Kelas kelas;
  final Promo promo;

  final int sisaDeposit;
  final int totalDeposit;

  Transaksi copyWith({
    String? noNota,
    Pegawai? kasir,
    Member? member,
    String? jenisTransaksi,
    String? tanggalTransaksi,
    String? nominalDeposit,
    Kelas? kelas,
    Promo? promo,
    int? sisaDeposit,
    int? totalDeposit,
  }) {
    return Transaksi(
      noNota: noNota ?? this.noNota,
      kasir: kasir ?? this.kasir,
      member: member ?? this.member,
      jenisTransaksi: jenisTransaksi ?? this.jenisTransaksi,
      tanggalTransaksi: tanggalTransaksi ?? this.tanggalTransaksi,
      nominalDeposit: nominalDeposit ?? this.nominalDeposit,
      kelas: kelas ?? this.kelas,
      promo: promo ?? this.promo,
      sisaDeposit: sisaDeposit ?? this.sisaDeposit,
      totalDeposit: totalDeposit ?? this.totalDeposit,
    );
  }

  const Transaksi({
    this.noNota = '',
    this.kasir = Pegawai.empty,
    this.member = Member.empty,
    this.jenisTransaksi = '',
    this.tanggalTransaksi = '',
    this.nominalDeposit = '',
    this.kelas = Kelas.empty,
    this.sisaDeposit = 0,
    this.totalDeposit = 0,
    this.promo = Promo.empty,
  });

  static const empty = Transaksi(
    noNota: '',
    kasir: Pegawai.empty,
    member: Member.empty,
    jenisTransaksi: '',
    tanggalTransaksi: '',
    nominalDeposit: '',
    kelas: Kelas.empty,
    sisaDeposit: 0,
    totalDeposit: 0,
    promo: Promo.empty,
  );

  bool get isEmpty => this == Transaksi.empty;
  bool get isNoEmpty => this != Transaksi.empty;
  @override
  List<Object?> get props => [
        noNota,
        kasir,
        member,
        jenisTransaksi,
        tanggalTransaksi,
        nominalDeposit,
        kelas,
        sisaDeposit,
        totalDeposit,
        promo,
      ];
}
