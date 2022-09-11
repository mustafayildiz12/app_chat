import 'package:app_chat/core/repostiroy/auth_response.dart';
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

  Future<void> registerWithProvider(
      String email, String password, BuildContext? context) async {
    AuthRepsonse<String> authRepsonse = await UserService()
        .register(email: email, password: password, context: context);

    UserModel userModel = UserModel(
      uid: authRepsonse.data ?? "zama",
      username: username!,
      email: email,
      password: password,
    );
    UserProvider userProvider =
        Provider.of<UserProvider>(context!, listen: false);
    userProvider.usermodel = userModel;
    await DatabaseService().createAccount(userModel);
    //   await DatabaseService().savePhoneNumber(phoneNumber!, uid!);
    //   await DatabaseService().saveUsernames(username!, uid!);
  }

  void notify() {
    notifyListeners();
  }
}
