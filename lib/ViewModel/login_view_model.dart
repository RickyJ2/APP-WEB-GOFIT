import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/pegawai.dart';
import 'dart:convert';
import '../const.dart';

class LoginViewModel extends ChangeNotifier {
  String? _usernameError;
  String? _passwordError;

  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;

  Future<Pegawai> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${uri}Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 201) {
      return Pegawai.fromJson(jsonDecode(response.body));
    } else {
      _usernameError = response.body;
      throw Exception('Failed to login');
    }
  }
}
