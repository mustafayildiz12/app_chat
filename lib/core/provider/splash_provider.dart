import 'dart:async';

import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/ui/pages/auth/main_auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../ui/pages/bottoms/bottom_page.dart';
import '../models/user_model.dart';
import '../repostiroy/user_repository.dart';

class SplashProvider extends ChangeNotifier {
  bool navigated = false;
  bool loggedIn = false;
  bool userHasLoggedIn = false;

  Duration duration = const Duration(seconds: 10);

  Future<void> init(context) async {
    if (!navigated) {
      navigated = true;
      checkAuthStatus(context);
    }
  }

  Future<void> checkAuthStatus(context) async {
    User? currentUser = UserService().getCurrentUser();
    if (currentUser != null) {
      debugPrint('user logged in');
    } else {
      debugPrint('user not logged in');
    }
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    if (currentUser != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      DataSnapshot dataSnapshot =
          await ref.child('users').child(currentUser.uid).get();
      if (dataSnapshot.exists) {
        Map data = dataSnapshot.value as Map;

        UserModel newUser = UserModel.fromMap(data);
        userProvider.usermodel = newUser;

        userProvider.notify();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomPage()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainAuthPage()),
            (route) => false);
      }
      await Future.delayed(const Duration(seconds: 3));

      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainAuthPage()),
        (route) => false);
  }
}
