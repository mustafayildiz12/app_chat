import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../repostiroy/user_repository.dart';
import '../service/database_service.dart';
import 'user_provider.dart';

class RegisterProvider extends ChangeNotifier {
  String? uid;
  String? username;
  String? email;
  String? password;
  String? profileImage;
  bool isLoginPage = false;

  Future<void> registerWithProvider(
      String email, String password, BuildContext? context) async {
    await UserService()
        .register(email: email, password: password, context: context);

    UserModel userModel = UserModel(
        uid: uid ?? 'zaza',
        username: username!,
        myFollowers: [],
        email: email,
        password: password,
        profileImage: profileImage ?? '');
    UserProvider userProvider =
        Provider.of<UserProvider>(context!, listen: false);
    userProvider.usermodel = userModel;

    await DatabaseService().createAccount(userModel);

    //   await DatabaseService().savePhoneNumber(phoneNumber!, uid!);
    await DatabaseService().saveUsernames(username!, uid!);
  }

  void notify() {
    notifyListeners();
  }
}
