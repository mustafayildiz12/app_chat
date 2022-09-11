import 'package:app_chat/ui/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/register_provider.dart';
import 'auth_response.dart';

class UserService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;

  Future<AuthRepsonse<User>> login(
      {required String email, required String password}) async {
    late UserCredential userCredential;

    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Geçersiz e-posta.';
      } else if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunmamaktadır.';
      } else if (e.code == 'wrong-password') {
        message = 'Hatalı e-posta veya şifre.';
      }

      return AuthRepsonse(
        isSuccessful: false,
        message: message,
      );
    } catch (e) {
      return AuthRepsonse(isSuccessful: false, message: 'Hata oluştu. $e');
    }
    return AuthRepsonse(
      isSuccessful: true,
      message: 'Başarıyla hesap oluşturuldu.',
      data: userCredential.user,
    );
  }

  Future<AuthRepsonse<String>> register(
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
          .whenComplete(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
      });
      registerProvider.uid = userCredential.user!.uid;
      registerProvider.notify();
      print("zaza");
      return AuthRepsonse(
          isSuccessful: true,
          message: "success",
          data: userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("Weak Password");
      } else if (e.code == 'email-already-in-use') {
        print("Same email");
      }
    } catch (e) {
      print(e);
    }
    return AuthRepsonse(
        isSuccessful: true, message: "success", data: registerProvider.uid);
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> logout(context) async {
    await firebaseAuth.signOut();
    // BottomNavBarProvider bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context, listen: false);
    // bottomNavBarProvider.setCurrentIndex(2);

    //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthRedirectScreen()), (route) => false);
  }
}
