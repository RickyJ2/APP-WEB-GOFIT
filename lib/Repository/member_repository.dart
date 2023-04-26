import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Model/member.dart';
import '../const.dart';
import '../token_bearer.dart';

class ErrorValidateFromMember implements Exception {
  final Member member;

  ErrorValidateFromMember(this.member);

  @override
  String toString() {
    return '${member.nama} ${member.alamat} ${member.tglLahir} ${member.noTelp} ${member.email} ${member.username} ${member.password}';
  }
}

class FailedToLoadMember implements Exception {
  final String message;

  FailedToLoadMember(this.message);
}

class MemberRepository {
  Future<List<Member>> get() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}member/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<Member> member = data.map((e) => Member.createMember(e)).toList();
      return member;
    } else {
      throw FailedToLoadMember('Failed to load member');
    }
  }

  Future<void> register(Member member) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}member/register');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'nama': member.nama,
      'alamat': member.alamat,
      'tgl_lahir': member.tglLahir,
      'email': member.email,
      'no_telp': member.noTelp,
      'username': member.username,
      'password': member.password!,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      Member memberError = const Member();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('nama')) {
        memberError = memberError.copyWith(nama: decoded['nama'][0].toString());
      }
      if (decoded.containsKey('alamat')) {
        memberError =
            memberError.copyWith(alamat: decoded['alamat'][0].toString());
      }
      if (decoded.containsKey('tgl_lahir')) {
        memberError =
            memberError.copyWith(tglLahir: decoded['tgl_lahir'][0].toString());
      }
      if (decoded.containsKey('email')) {
        memberError =
            memberError.copyWith(email: decoded['email'][0].toString());
      }
      if (decoded.containsKey('no_telp')) {
        memberError =
            memberError.copyWith(noTelp: decoded['no_telp'][0].toString());
      }
      if (decoded.containsKey('username')) {
        memberError =
            memberError.copyWith(username: decoded['username'][0].toString());
      }
      if (decoded.containsKey('password')) {
        memberError =
            memberError.copyWith(password: decoded['password'][0].toString());
      }
      throw ErrorValidateFromMember(memberError);
    } else {
      throw const HttpException('Failed to register member');
    }
  }

  Future<List<Member>> find(String data) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}member/find');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'data': data,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<Member> member = data.map((e) => Member.createMember(e)).toList();
      return member;
    } else {
      throw FailedToLoadMember('Failed to load member');
    }
  }

  Future<void> update(Member member) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}member/update/${member.id}');
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'nama': member.nama,
      'alamat': member.alamat,
      'tgl_lahir': member.tglLahir,
      'email': member.email,
      'no_telp': member.noTelp,
      'username': member.username,
      'password': member.password!,
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      Member memberError = const Member();
      final decoded = json.decode(response.body)['message'];

      if (decoded.containsKey('nama')) {
        memberError = memberError.copyWith(nama: decoded['nama'][0].toString());
      }
      if (decoded.containsKey('alamat')) {
        memberError =
            memberError.copyWith(alamat: decoded['alamat'][0].toString());
      }
      if (decoded.containsKey('tgl_lahir')) {
        memberError =
            memberError.copyWith(tglLahir: decoded['tgl_lahir'][0].toString());
      }
      if (decoded.containsKey('email')) {
        memberError =
            memberError.copyWith(email: decoded['email'][0].toString());
      }
      if (decoded.containsKey('no_telp')) {
        memberError =
            memberError.copyWith(noTelp: decoded['no_telp'][0].toString());
      }
      if (decoded.containsKey('username')) {
        memberError =
            memberError.copyWith(username: decoded['username'][0].toString());
      }
      if (decoded.containsKey('password')) {
        memberError =
            memberError.copyWith(password: decoded['password'][0].toString());
      }
      throw ErrorValidateFromMember(memberError);
    } else {
      throw const HttpException('Failed to register member');
    }
  }

  Future<void> delete(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}member/$id');
    var response =
        await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw const HttpException('Failed to delete member');
    }
  }

  Future<void> resetPassword(String id) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}member/resetPassword/$id');
    var response =
        await http.put(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return;
    } else {
      throw const HttpException('Failed to reset password');
    }
  }
}
