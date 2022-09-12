import 'package:app_chat/core/class/screen_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/register_provider.dart';
import '../product/loading_button.dart';

class RegisterPage extends StatelessWidget {
  final PageController pageController;
  const RegisterPage({required this.pageController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      body: Container(
        decoration:  BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (v) {
                  registerProvider.username = v;
                  registerProvider.notify();
                },
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Username" : null,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Username",
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (v) {
                  registerProvider.email = v;
                  registerProvider.notify();
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
                  registerProvider.password = v;
                  registerProvider.notify();
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
                  await registerProvider.registerWithProvider(
                      registerProvider.email!.trim(),
                      registerProvider.password!.trim(),
                      context);

                  print(registerProvider.email);
                  print(registerProvider.password);
                  print(registerProvider.username);
                },
                title: "Register"),
                SizedBox(
                  height: Screen.height(context)*4,
                ),
          ],
        ),
      ),
    );
  }
}
