import 'dart:developer';

import 'package:actividad_desis/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final String apiUrl = "https://randomuser.me/api/";
  final String apiKey =
      dotenv.get('API_WEATHER', fallback: 'URL env is required');

  Future<User?> fetchUser() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      log(json['results'][0].toString());
      final userJson = json['results'][0];
      return User.fromJson(userJson);
    }
    return null;
  }

  Future<Map<String, dynamic>> getLocation(String city) async {
    String api =
        "http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=5&appid=$apiKey";
    final response = await http.get(Uri.parse(api));
    final json = jsonDecode(response.body);
    return json[0];
  }

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    String api =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";
    final response = await http.get(Uri.parse(api));
    final json = jsonDecode(response.body);
    return json;
  }
}
