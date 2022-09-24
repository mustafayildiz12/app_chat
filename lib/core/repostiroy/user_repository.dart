import 'package:app_chat/core/provider/auth_provider.dart';
import 'package:app_chat/ui/pages/bottoms/bottom_page.dart';
import 'package:app_chat/ui/pages/pageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../provider/register_provider.dart';
import '../provider/user_provider.dart';

class UserService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;

  Future<void> login(
      {required String email,
      required String password,
      BuildContext? context}) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context!, listen: false);
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      late DataSnapshot snapshot;
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      await firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        user = FirebaseAuth.instance.currentUser;

        snapshot = await ref.child('users').child(user!.uid).get();
        print('id${user!.uid}');
        if (snapshot.exists) {
          Map data = snapshot.value as Map;
          data['key'] = snapshot.key;

          UserModel newUser = UserModel.fromMap(data);

          userProvider.usermodel = newUser;
          userProvider.notify();
        }
        if (user != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomPage()),
              (route) => false);
        }
      });
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Geçersiz e-posta.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
        authProvider.isLoginLoading = false;
        authProvider.notify();
      } else if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunmamaktadır.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
        authProvider.isLoginLoading = false;
        authProvider.notify();
      } else if (e.code == 'wrong-password') {
        message = 'Hatalı e-posta veya şifre.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
        authProvider.isLoginLoading = false;
        authProvider.notify();
      }
    }
  }

  Future<void> register(
      {required String email,
      required String password,
      BuildContext? context}) async {
    RegisterProvider registerProvider =
        Provider.of<RegisterProvider>(context!, listen: false);
    try {
      final userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((v) {
        if (v.user == null) {
          print("null");
        } else {
          registerProvider.uid = v.user!.uid;
          registerProvider.notify();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomPage()),
              (route) => false);
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Geçersiz e-posta.'),
        ));
        registerProvider.isRegistering = false;
        registerProvider.notify();
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Weak Password"),
        ));
        registerProvider.isRegistering = false;
        registerProvider.notify();
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("email-already-in-use"),
        ));
        registerProvider.isRegistering = false;
        registerProvider.notify();
      }
    } catch (e) {
      print(e);
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> logout(context) async {
    await firebaseAuth.signOut();
    // BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context, listen: false);
    // bottomNavBarProvider.setCurrentIndex(2);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PageViewNavPage()),
        (route) => false);
  }

  Future<void> chechUsername(String username, BuildContext context) async {
    RegisterProvider registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await ref.child('usernames').child(username).get();

    if (snapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The username already in use!'),
      ));
      registerProvider.isAvailable = false;
      registerProvider.notify();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('The username is available'),
      ));
      registerProvider.isAvailable = true;
      registerProvider.notify();
    }
  }
}
