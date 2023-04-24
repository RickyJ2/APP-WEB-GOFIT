import 'package:http/http.dart' as http;
import 'package:web_gofit/LoginBloc/login_repository.dart';
import 'dart:convert';
import '../const.dart';
import '../Model/instruktur.dart';
import '../token_bearer.dart';

class ErrorValidatedFromInstruktur implements Exception {
  final Instruktur message;

  ErrorValidatedFromInstruktur(this.message);

  @override
  String toString() =>
      '${message.nama} ${message.alamat} ${message.tglLahir} ${message.noTelp} ${message.username} ${message.password}';
}

class FailedToLoadInstruktur implements Exception {
  final String message;

  FailedToLoadInstruktur(this.message);
}

class InstrukturRepository {
  Future<List<Instruktur>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}instruktur/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<Instruktur> instruktur =
          data.map((e) => Instruktur.createInstruktur(e)).toList();
      return instruktur;
    } else {
      throw FailedToLoadInstruktur('Failed to load instruktur');
    }
  }

  Future<void> register(Instruktur instruktur) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}instruktur/register');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'nama': instruktur.nama,
      'alamat': instruktur.alamat,
      'tgl_lahir': instruktur.tglLahir,
      'no_telp': instruktur.noTelp,
      'username': instruktur.username,
      'password': instruktur.password!,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      Instruktur instrukturError = const Instruktur();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('nama')) {
        instrukturError =
            instrukturError.copyWith(nama: decoded['nama'][0].toString());
      }
      if (decoded.containsKey('alamat')) {
        instrukturError =
            instrukturError.copyWith(alamat: decoded['alamat'][0]);
      }
      if (decoded.containsKey('tgl_lahir')) {
        instrukturError =
            instrukturError.copyWith(tglLahir: decoded['tgl_lahir'][0]);
      }
      if (decoded.containsKey('no_telp')) {
        instrukturError =
            instrukturError.copyWith(noTelp: decoded['no_telp'][0]);
      }
      if (decoded.containsKey('username')) {
        instrukturError =
            instrukturError.copyWith(username: decoded['username'][0]);
      }
      if (decoded.containsKey('password')) {
        instrukturError =
            instrukturError.copyWith(password: decoded['password'][0]);
      }
      throw ErrorValidatedFromInstruktur(instrukturError);
    } else {
      throw HttpException('Failed to register instruktur');
    }
  }

  Future<List<Instruktur>> find(String data) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}instruktur/find');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'data': data,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<Instruktur> instruktur =
          data.map((e) => Instruktur.createInstruktur(e)).toList();
      return instruktur;
    } else {
      throw FailedToLoadInstruktur('Failed to load instruktur');
    }
  }

  Future<void> update(Instruktur instruktur) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}instruktur/update/${instruktur.id}');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'nama': instruktur.nama,
      'alamat': instruktur.alamat,
      'tgl_lahir': instruktur.tglLahir,
      'no_telp': instruktur.noTelp,
      'username': instruktur.username,
    });
    if (response.statusCode == 200) {
      return;
    }
    if (response.statusCode == 400) {
      Instruktur instrukturError = const Instruktur();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('nama')) {
        instrukturError =
            instrukturError.copyWith(nama: decoded['nama'][0].toString());
      }
      if (decoded.containsKey('alamat')) {
        instrukturError =
            instrukturError.copyWith(alamat: decoded['alamat'][0]);
      }
      if (decoded.containsKey('tgl_lahir')) {
        instrukturError =
            instrukturError.copyWith(tglLahir: decoded['tgl_lahir'][0]);
      }
      if (decoded.containsKey('no_telp')) {
        instrukturError =
            instrukturError.copyWith(noTelp: decoded['no_telp'][0]);
      }
      if (decoded.containsKey('username')) {
        instrukturError =
            instrukturError.copyWith(username: decoded['username'][0]);
      }
      throw ErrorValidatedFromInstruktur(instrukturError);
    } else {
      throw HttpException('Failed to update instruktur');
    }
  }

  Future<void> delete(int id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}instruktur/$id');
    var response =
        await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw HttpException('Failed to delete instruktur');
    }
  }
}
