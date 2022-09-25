import 'dart:async';

import 'package:app_chat/ui/pages/auth/main_auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../repostiroy/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserModel? usermodel;
  String? updateUsername;

  Future<void> initUser(context) async {
    User? currentUser = UserService().getCurrentUser();

    if (currentUser == null) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainAuthPage()),
          (route) => false);

      return;
    } else {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot dataSnapshot =
          await ref.child('users').child(currentUser.uid).get();

      if (dataSnapshot.exists) {
        print("1.1");
        Map data = dataSnapshot.value as Map;
        data['key'] = dataSnapshot.key;

        UserModel newUser = UserModel.fromMap(data);

        userProvider.usermodel = newUser;
        userProvider.notify();
        Timer(
            const Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => const MainAuthPage())));
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /*
  Future<void> getUser(
      String verificationId, String pass, BuildContext context) async {
    await UserService().verifyOtpLogin(
        code: pass, verificationID: verificationId, context: context);
  }
  */

  /*
  void updateUser() {
    DatabaseService().getUser(usermodel!.uid).then((value) {
      usermodel = value;
      notifyListeners();
    });
  }
   */

  void notify() {
    notifyListeners();
  }
}
