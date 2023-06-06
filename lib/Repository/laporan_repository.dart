import 'dart:convert';
import 'dart:io';

import 'package:web_gofit/Model/laporan_aktivitas_gym.dart';
import 'package:web_gofit/Model/laporan_aktivitas_kelas.dart';
import 'package:web_gofit/Model/laporan_kinerja_instruktur.dart';
import 'package:web_gofit/Model/laporan_pendapatan.dart';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadLaporan implements Exception {
  final String message;

  FailedToLoadLaporan(this.message);
}

class LaporanRepository {
  Future<List<LaporanPendapatan>> laporanPendapatan(String year) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}laporanPendapatan/$year');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<LaporanPendapatan> laporanPendapatan = data
          .map((e) => LaporanPendapatan.createLaporanPendapatan(e))
          .toList();
      return laporanPendapatan;
    } else {
      throw const HttpException('Failed to load Laporan');
    }
  }

  Future<List<LaporanAktivitasKelas>> laporanAktivitasKelas(
      String year, String month) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}laporanKelas/$year/$month');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<LaporanAktivitasKelas> laporanAktivitasKelas = data
          .map((e) => LaporanAktivitasKelas.createLaporanAktivitasKelas(e))
          .toList();
      return laporanAktivitasKelas;
    } else {
      throw const HttpException('Failed to load Laporan');
    }
  }

  Future<List<LaporanAktivitasGym>> laporanAktivitasGym(
      String year, String month) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}laporanGym/$year/$month');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<LaporanAktivitasGym> laporanAktivitasGym = data
          .map((e) => LaporanAktivitasGym.createLaporanAktivitasGym(e))
          .toList();
      return laporanAktivitasGym;
    } else {
      throw const HttpException('Failed to load Laporan');
    }
  }

  Future<List<LaporanKinerjaInstruktur>> laporanKinerjaInstruktur(
      String year, String month) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}laporanKinerjaInstruktur/$year/$month');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<LaporanKinerjaInstruktur> laporanKinerjaInstruktur = data
          .map(
              (e) => LaporanKinerjaInstruktur.createLaporanKinerjaInstruktur(e))
          .toList();
      return laporanKinerjaInstruktur;
    } else {
      throw const HttpException('Failed to load Laporan');
    }
  }
}
