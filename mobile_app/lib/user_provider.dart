import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _email = '';
  String _status = '';
  String _name = '';

  String get username => _username;
  String get email => _email;
  String get status => _status;
  String get name => _name;

  void setUser(Map<String, String> userDetails) {
    _username = userDetails['username'] ?? '';
    _email = userDetails['email'] ?? '';
    _status = userDetails['status'] ?? '';
    _name = userDetails['name'] ?? '';
    notifyListeners();
  }

  void clearUser() {
    _username = '';
    _email = '';
    _status = '';
    _name = '';
    notifyListeners();
  }
}
