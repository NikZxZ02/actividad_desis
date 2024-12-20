import 'package:actividad_desis/models/user.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  String _rut = '';
  String get rut => _rut;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void setRut(String newRut) {
    _rut = newRut;
    notifyListeners();
  }
}
