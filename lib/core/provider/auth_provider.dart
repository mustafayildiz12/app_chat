import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoginLoading = false;
  bool isLoginPage = false;
  String? email;
  String? password;

  void notify() {
    notifyListeners();
  }
}
