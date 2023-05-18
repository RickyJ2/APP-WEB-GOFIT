import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../Model/booking_gym.dart';
import '../const.dart';
import '../token_bearer.dart';

class FailedToLoadBookingGym implements Exception {
  final String message;

  FailedToLoadBookingGym(this.message);
}

class BookingGymRepository {
  Future<List<BookingGym>> index() async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingGym/index');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'] as List;
      List<BookingGym> bookingKelas =
          data.map((e) => BookingGym.createBookingGym(e)).toList();
      return bookingKelas;
    } else {
      throw const HttpException('Failed to load Booking');
    }
  }

  Future<void> updatePresent(BookingGym bookingGym) async {
    var token = await TokenBearer().get();
    var url = Uri.parse('${uri}bookingGym/updatePresent');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'id': bookingGym.id,
      'member_id': bookingGym.member.id,
      'jenis_transaksi_id': '4',
    });
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw FailedToLoadBookingGym(json.decode(response.body)['message']);
    } else {
      throw const HttpException('Failed to update present Booking');
    }
  }
}
