import 'package:flutter/material.dart';
import 'package:postman_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  UserLogin? _user;
  bool _isLoading = false;

  UserLogin? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call or any authentication logic
    await Future.delayed(const Duration(seconds: 2));

    // Assuming successful login, save user details
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', '1');
    prefs.setString('ruqaiya', username);
    prefs.setString('email', 'ruqaiya@NextGeni.com');

    _user = UserLogin(id: '1', username: username, email: 'ruqaiya@NextGeni.com');
    _isLoading = false;

    notifyListeners();
  }

  Future<void> logout() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? username = prefs.getString('username');
    final String? email = prefs.getString('email');

    if (userId != null && username != null && email != null) {
      _user = UserLogin(id: userId, username: username, email: email);
    }

    notifyListeners();
  }

}
