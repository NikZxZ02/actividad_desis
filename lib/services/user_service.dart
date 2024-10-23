import 'package:actividad_desis/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final String apiUrl = "https://randomuser.me/api/";

  Future<User?> fetchUser() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userJson = json['results'][0];
      return User.fromJson(userJson);
    }
    return null;
  }
}
