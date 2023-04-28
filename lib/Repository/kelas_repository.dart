import 'dart:convert';
import '../Model/kelas.dart';
import '../const.dart';
import '../token_bearer.dart';
import 'package:http/http.dart' as http;

class FailedToLoadKelas implements Exception {
  final String message;

  FailedToLoadKelas(this.message);
}

class KelasRepository {
  Future<List<Kelas>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}kelas/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<Kelas> kelas = data.map((e) => Kelas.createKelas(e)).toList();
      return kelas;
    } else {
      throw FailedToLoadKelas('Failed to load kelas');
    }
  }
}
