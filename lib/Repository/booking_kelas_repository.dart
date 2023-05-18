import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../Model/booking_kelas.dart';
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadBookingKelas implements Exception {
  final String message;

  FailedToLoadBookingKelas(this.message);
}

class BookingKelasRepository {
  Future<List<BookingKelas>> show() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingKelas/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<BookingKelas> bookingKelas =
          data.map((e) => BookingKelas.createBookingKelas(e)).toList();
      return bookingKelas;
    } else {
      throw const HttpException('Failed to load Booking');
    }
  }
}
