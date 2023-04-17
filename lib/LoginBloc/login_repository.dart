import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const.dart';
import '../Model/pegawai.dart';

class LogInWithUsernamePasswordFailure implements Exception {
  final Map<String, String> message;

  LogInWithUsernamePasswordFailure(this.message);

  @override
  String toString() {
    return '${message['username']} ${message['password']}';
  }
}

class LogInWithFailure implements Exception {
  final String message;

  LogInWithFailure(this.message);
}

class LogOutWithFailure implements Exception {
  final String message;

  LogOutWithFailure(this.message);
}

class GetUserFailure implements Exception {
  final String message;

  GetUserFailure(this.message);
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}

class LoginRepository {
  Future<void> login(String username, String password) async {
    var url = Uri.parse('${uri}loginWeb');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      //sukses, simpan token
      var token = json.decode(response.body)['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(sharedPrefKey['token']!, token);
    } else if (response.statusCode == 400) {
      //username atau password kosong
      String usernameError = '';
      String passwordError = '';
      final decoded = json.decode(response.body)['data'];
      if (decoded.containsKey('username')) {
        usernameError = decoded['username'][0];
      }
      if (decoded.containsKey('password')) {
        passwordError = decoded['password'][0];
      }
      var msg = {
        'username': usernameError.toString(),
        'password': passwordError.toString(),
      };
      throw LogInWithUsernamePasswordFailure(msg);
    } else if (response.statusCode == 401) {
      //akun tidak ditemukan
      throw LogInWithFailure('Username or password is incorrect');
    } else {
      throw HttpException(
          'There is something wrong with the server or connection');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${uri}logout');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${prefs.getString(sharedPrefKey['token']!)}'
    });
    if (response.statusCode == 200) {
      //sukses, hapus token
      prefs.remove(sharedPrefKey['token']!);
    } else {
      //terjadi kesalahan
      throw LogOutWithFailure(
          'There is something wrong with the server or connection');
    }
  }

  Future<Pegawai> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${uri}pegawai/index');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${prefs.getString(sharedPrefKey['token']!)}'
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      return Pegawai.createPegawai(data);
    } else {
      throw GetUserFailure(
          'There is something wrong with the server or connection');
    }
  }
}
