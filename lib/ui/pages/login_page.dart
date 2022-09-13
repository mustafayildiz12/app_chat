import 'package:app_chat/core/repostiroy/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/class/screen_class.dart';
import '../../core/provider/user_provider.dart';

class LoginPage extends StatefulWidget {
  final PageController pageController;
  const LoginPage({required this.pageController, Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isValid = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pasword = TextEditingController();
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
                controller: _email,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _pasword,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_pasword.text.isEmpty || _email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Fill all the infos'),
                    ));
                  } else {
                    await UserService().login(
                        email: _email.text,
                        password: _pasword.text,
                        context: context);
                    userProvider.usermodel!.email = _email.text;
                    userProvider.usermodel!.password = _pasword.text;
                    userProvider.notify();
                  }
                },
                child: const Text("Login")),
            SizedBox(
              height: Screen.height(context) * 4,
            ),
          ],
        ),
      ),
    );
  }
}
