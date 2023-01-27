import 'package:ceeb_mobile/controllers/user_controller.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _name;
  String? _username;
  String? _password;

  bool get isAuth {
    // return _token != null ? true : false;
    return true;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get name {
    return isAuth ? _name : null;
  }

  String? get username {
    return isAuth ? _username : null;
  }

  String? get password {
    return isAuth ? _password : null;
  }

  Future<void> authenticate(String username, String password) async {
    final userController = UserController();
    final user = await userController.login(username, password);

    _token = user.token;
    _name = user.name;
    _username = user.username;

    notifyListeners();
  }
}
