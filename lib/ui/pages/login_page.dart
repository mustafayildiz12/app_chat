import 'package:app_chat/core/repostiroy/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/class/screen_class.dart';
import '../../core/provider/user_provider.dart';
import '../product/loading_button.dart';

class LoginPage extends StatelessWidget {
  final PageController pageController;
  const LoginPage({required this.pageController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.pink, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (v) {
                  userProvider.usermodel!.email = v;
                },
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Email" : null,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (v) {
                  userProvider.usermodel!.password = v;
                },
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Password" : null,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    border: OutlineInputBorder()),
              ),
            ),
            LoadingButton(
                onPressed: () async {
                  UserService().login(
                      email: userProvider.usermodel!.email,
                      password: userProvider.usermodel!.password,
                      context: context);
                },
                title: "Login"),
            SizedBox(
              height: Screen.height(context) * 4,
            ),
          ],
        ),
      ),
    );
  }
}
