import 'package:flutter/material.dart';

class AuthFieldNotifier extends ChangeNotifier {
  bool isValidEmail = false;
  bool isValidPassword = false;
  bool canKeepEmail = true;
  String email = '';
  String password = '';

  void notifyEmailValidation(bool isValid) {
    isValidEmail = isValid;
    notifyListeners();
  }

  void notifyPasswordValidation(bool isValid) {
    isValidPassword = isValid;
    notifyListeners();
  }

  bool isValidAll() => isValidEmail && isValidPassword;
}
