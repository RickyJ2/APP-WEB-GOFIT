import 'package:shared_preferences/shared_preferences.dart';

class TokenFailure implements Exception {
  final String message;

  TokenFailure(this.message);
}

class TokenBearer {
  final sharedPrefKey = {'token': 'tokenKey'};
  Future<String> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenPref = prefs.getString(sharedPrefKey['token']!);
    if (tokenPref == null) {
      throw TokenFailure('Token is null');
    }
    return tokenPref;
  }

  Future<void> save(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPrefKey['token']!, token);
  }

  Future<void> remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sharedPrefKey['token']!);
  }
}
