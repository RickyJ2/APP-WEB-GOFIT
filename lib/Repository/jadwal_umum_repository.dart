import 'dart:convert';

import 'package:web_gofit/Model/jadwal_umum.dart';
import 'package:http/http.dart' as http;
import 'package:web_gofit/Model/jadwal_umum_formated.dart';
import 'package:web_gofit/Repository/login_repository.dart';
import '../const.dart';
import '../token_bearer.dart';

class ErrorValidatedFromJadwalUmum implements Exception {
  final JadwalUmum message;
  ErrorValidatedFromJadwalUmum(this.message);

  @override
  String toString() =>
      '${message.kelas.id} ${message.instruktur.id} ${message.hari} ${message.jamMulai}';
}

class FailedToLoadJadwalUmum implements Exception {
  final String message;

  FailedToLoadJadwalUmum(this.message);
}

class JadwalUmumRepository {
  Future<List<JadwalUmumFormated>> get() async {
    var url = Uri.parse('${uri}jadwalUmum/index');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as Map<String, dynamic>;
      List<JadwalUmumFormated> jadwalUmum = [];
      data.forEach((key, value) {
        jadwalUmum.add(JadwalUmumFormated.createJadwalUmumFormated(key, value));
      });
      return jadwalUmum;
    } else {
      throw FailedToLoadJadwalUmum('Failed to load jadwal umum');
    }
  }

  Future<void> add(JadwalUmum jadwalUmum) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalUmum/add');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'instruktur_id': jadwalUmum.instruktur.id,
      'kelas_id': jadwalUmum.kelas.id,
      'hari': jadwalUmum.hari,
      'jam_mulai': jadwalUmum.jamMulai,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      JadwalUmum jadwalUmumError = const JadwalUmum();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('instruktur_id')) {
        jadwalUmumError = jadwalUmumError.copyWith(
            instruktur: jadwalUmum.instruktur
                .copyWith(id: decoded['instruktur_id'][0].toString()));
      }
      if (decoded.containsKey('kelas_id')) {
        jadwalUmumError = jadwalUmumError.copyWith(
            kelas: jadwalUmum.kelas
                .copyWith(id: decoded['kelas_id'][0].toString()));
      }
      if (decoded.containsKey('hari')) {
        jadwalUmumError =
            jadwalUmumError.copyWith(hari: decoded['hari'][0].toString());
      }
      if (decoded.containsKey('jam_mulai')) {
        jadwalUmumError = jadwalUmumError.copyWith(
            jamMulai: decoded['jam_mulai'][0].toString());
      }
      throw ErrorValidatedFromJadwalUmum(jadwalUmumError);
    } else {
      throw HttpException('Failed to add jadwal umum');
    }
  }

  Future<void> update(JadwalUmum jadwalUmum) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalUmum/update/${jadwalUmum.id}');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'instruktur_id': jadwalUmum.instruktur.id,
      'kelas_id': jadwalUmum.kelas.id,
      'hari': jadwalUmum.hari,
      'jam_mulai': jadwalUmum.jamMulai,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      JadwalUmum jadwalUmumError = const JadwalUmum();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('instruktur_id')) {
        jadwalUmumError = jadwalUmumError.copyWith(
            instruktur: jadwalUmum.instruktur
                .copyWith(id: decoded['instruktur_id'][0].toString()));
      }
      if (decoded.containsKey('kelas_id')) {
        jadwalUmumError = jadwalUmumError.copyWith(
            kelas: jadwalUmum.kelas
                .copyWith(id: decoded['kelas_id'][0].toString()));
      }
      if (decoded.containsKey('hari')) {
        jadwalUmumError =
            jadwalUmumError.copyWith(hari: decoded['hari'][0].toString());
      }
      if (decoded.containsKey('jam_mulai')) {
        jadwalUmumError = jadwalUmumError.copyWith(
            jamMulai: decoded['jam_mulai'][0].toString());
      }
      throw ErrorValidatedFromJadwalUmum(jadwalUmumError);
    } else {
      throw HttpException('Failed to update jadwal umum');
    }
  }

  Future<void> delete(int id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalUmum/$id');
    var response =
        await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw HttpException('Failed to delete Jadwal Umum');
    }
  }
}
