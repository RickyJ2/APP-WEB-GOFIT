import 'dart:convert';

import 'package:web_gofit/Model/transaksi.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../token_bearer.dart';

class ErrorValidateFromTransaksi implements Exception {
  final Transaksi transaksi;
  ErrorValidateFromTransaksi(this.transaksi);

  @override
  String toString() {
    return '${transaksi.member.id} ${transaksi.jenisTransaksi} ${transaksi.nominalDeposit} ${transaksi.kelas.id} ${transaksi.totalDeposit}';
  }
}

class TransaksiRepository {
  Future<Transaksi> aktivasi(Transaksi transaksi) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}transaksi/aktivasi');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'member_id': transaksi.member.id.toString(),
      'jenis_transaksi_id': '1',
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      Transaksi struk = transaksi.copyWith(
        noNota: data['no_nota'],
        member: transaksi.member
            .copyWith(deactivedMembershipAt: data['masa_aktif_member']),
        tanggalTransaksi: data['created_at'],
      );
      return struk;
    } else if (response.statusCode == 400) {
      throw ErrorValidateFromTransaksi(transaksi);
    } else {
      throw Exception('Failed to do transaksi');
    }
  }

  Future<Transaksi> depositReguler(Transaksi transaksi) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}transaksi/depositReguler');
    var body = transaksi.promo.isEmpty
        ? {
            'member_id': transaksi.member.id.toString(),
            'jenis_transaksi_id': '2',
            'nominal': transaksi.nominalDeposit.toString(),
          }
        : {
            'member_id': transaksi.member.id.toString(),
            'jenis_transaksi_id': '2',
            'nominal': transaksi.nominalDeposit.toString(),
            'promo_id': transaksi.promo.id.toString(),
          };

    var response = await http.post(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      Transaksi struk = transaksi.copyWith(
        noNota: data['no_nota'],
        sisaDeposit: data['sisa_deposit'],
        totalDeposit: data['total_deposit'],
        tanggalTransaksi: data['created_at'],
      );
      return struk;
    } else if (response.statusCode == 400) {
      throw ErrorValidateFromTransaksi(transaksi);
    } else {
      throw Exception('Failed to do transaksi');
    }
  }

  Future<Transaksi> depositKelasPaket(Transaksi transaksi) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}transaksi/depositKelasPaket');
    var body = transaksi.promo.isEmpty
        ? {
            'member_id': transaksi.member.id.toString(),
            'jenis_transaksi_id': '3',
            'kelas_id': transaksi.kelas.id.toString(),
            'nominal': transaksi.nominalDeposit.toString(),
            'total': transaksi.totalDeposit.toString(),
          }
        : {
            'member_id': transaksi.member.id.toString(),
            'jenis_transaksi_id': '3',
            'kelas_id': transaksi.kelas.id.toString(),
            'nominal': transaksi.nominalDeposit.toString(),
            'total': transaksi.totalDeposit.toString(),
            'promo_id': transaksi.promo.id.toString(),
          };

    var response = await http.post(url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      Transaksi struk = transaksi.copyWith(
        noNota: data['no_nota'],
        member: transaksi.member.copyWith(
          deactivedDepositKelasPaket: data['masa_aktif_deposit_kelas_paket'],
        ),
        totalDeposit: data['total_deposit'],
        tanggalTransaksi: data['created_at'],
      );
      return struk;
    } else if (response.statusCode == 400) {
      throw ErrorValidateFromTransaksi(transaksi);
    } else {
      throw Exception('Failed to do transaksi');
    }
  }
}
