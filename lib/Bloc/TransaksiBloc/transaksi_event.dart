import 'package:web_gofit/Model/kelas.dart';
import 'package:web_gofit/Model/transaksi.dart';

import '../../Model/member.dart';

abstract class TransaksiEvent {}

class PageDataFetched extends TransaksiEvent {}

class MemberFormChanged extends TransaksiEvent {
  final Member member;
  MemberFormChanged({required this.member});
}

class JenisTransaksiFormChanged extends TransaksiEvent {
  final String jenisTransaksi;
  JenisTransaksiFormChanged({required this.jenisTransaksi});
}

class NominalFormChanged extends TransaksiEvent {
  final String nominal;
  NominalFormChanged({required this.nominal});
}

class KelasFormChanged extends TransaksiEvent {
  final Kelas kelas;
  KelasFormChanged({required this.kelas});
}

class CashFormChanged extends TransaksiEvent {
  final int cash;
  CashFormChanged({required this.cash});
}

class TransaksiFormInputErrorChanged extends TransaksiEvent {
  final Transaksi transaksiError;
  TransaksiFormInputErrorChanged({required this.transaksiError});
}

class CancelTransaksiRequested extends TransaksiEvent {}

class TransaksiFormSubmitted extends TransaksiEvent {}
