import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:web_gofit/Model/izin_instruktur.dart';

import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadIizinInstruktur implements Exception {
  final String message;

  FailedToLoadIizinInstruktur(this.message);
}

class IzinInstrukturRepository {
  Future<List<IzinInstruktur>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}izinInstruktur/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<IzinInstruktur> izinInstruktur =
          data.map((e) => IzinInstruktur.createIzinInstruktur(e)).toList();
      return izinInstruktur;
    } else {
      throw FailedToLoadIizinInstruktur('Failed to load member');
    }
  }

  Future<void> confirmed(String id, int state) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}izinInstruktur/verifikasi/$id');
    var response = await http.put(url,
        headers: {'Authorization': 'Bearer $token'},
        body: {'is_confirmed': state.toString()});
    if (response.statusCode == 200) {
      return;
    } else {
      throw const HttpException('Failed to konfirmasi izin Instruktur');
    }
  }
}
