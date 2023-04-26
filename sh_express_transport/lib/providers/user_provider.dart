import 'package:flutter/material.dart';
import 'package:sh_express_transport/models/user.dart';
import 'package:sh_express_transport/services/auth_services.dart';

class UserProvider extends ChangeNotifier {
  User _user;
  AuthServices _authServices = AuthServices();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authServices.getUserDetails();

    _user = user;

    notifyListeners();
  }
}
