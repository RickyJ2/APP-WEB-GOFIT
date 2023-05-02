import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/promo.dart';
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadPromo implements Exception {
  final String message;

  FailedToLoadPromo(this.message);
}

class PromoRepository {
  Future<List<Promo>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}promo/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<Promo> promo = data.map((e) => Promo.createPromo(e)).toList();
      return promo;
    } else {
      throw FailedToLoadPromo('Failed to load promo');
    }
  }
}
