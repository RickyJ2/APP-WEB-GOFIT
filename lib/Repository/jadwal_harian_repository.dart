import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Model/jadwal_harian_formated_list.dart';
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadJadwalHarian implements Exception {
  final String message;

  FailedToLoadJadwalHarian(this.message);
}

class JadwalHarianRepository {
  Future<List<JadwalHarianFormatedList>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as Map<String, dynamic>;
      List<JadwalHarianFormatedList> jadwalHarian = [];
      data.forEach((key, value) {
        jadwalHarian.add(
            JadwalHarianFormatedList.createJadwalHarianFormatedList(
                key, value));
      });
      return jadwalHarian;
    } else {
      throw FailedToLoadJadwalHarian('Failed to load jadwal harian');
    }
  }

  Future<void> generate() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/generate');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw FailedToLoadJadwalHarian(
          json.decode(response.body)['message'].toString());
    } else {
      throw FailedToLoadJadwalHarian('Failed to generate jadwal harian');
    }
  }

  Future<List<JadwalHarianFormatedList>> find(String data) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/find');
    var response = await http.post(url,
        headers: {'Authorization': 'Bearer $token'}, body: {'data': data});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as Map<String, dynamic>;
      List<JadwalHarianFormatedList> jadwalHarian = [];
      data.forEach((key, value) {
        jadwalHarian.add(
            JadwalHarianFormatedList.createJadwalHarianFormatedList(
                key, value));
      });
      return jadwalHarian;
    } else {
      throw FailedToLoadJadwalHarian('Failed to load jadwal harian');
    }
  }

  Future<void> updateLibur(int id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}jadwalHarian/libur/$id');
    var response =
        await http.post(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw FailedToLoadJadwalHarian('Failed to update jadwal harian');
    }
  }
}
