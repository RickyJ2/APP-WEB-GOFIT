import 'package:web_gofit/Model/informasi_umum.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const.dart';

class FailedToLoadInformasiUmum implements Exception {
  final String message;

  FailedToLoadInformasiUmum(this.message);
}

class InformasiUmumRepository {
  Future<InformasiUmum> get() async {
    var url = Uri.parse('${uri}infoUmum');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      InformasiUmum informasiUmum = InformasiUmum.createInformasiUmum(data);
      return informasiUmum;
    } else {
      throw FailedToLoadInformasiUmum('Failed to load informasi umum');
    }
  }
}
