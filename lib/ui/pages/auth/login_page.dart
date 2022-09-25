import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/class/screen_class.dart';
import '../../../core/provider/auth_provider.dart';
import '../../../core/repostiroy/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: authProvider.email,
                onChanged: (v) {
                  authProvider.email = v;
                  authProvider.notify();
                },
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
                  authProvider.password = v;
                  authProvider.notify();
                },
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (authProvider.email!.isEmpty ||
                      authProvider.password!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Fill all the infos'),
                    ));
                  } else {
                    authProvider.isLoginLoading = true;
                    authProvider.notify();
                    await UserService().login(
                        email: authProvider.email!.trim(),
                        password: authProvider.password!.trim(),
                        context: context);

                    authProvider.isLoginLoading = false;
                    authProvider.notify();
                  }
                },
                child: authProvider.isLoginLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).indicatorColor,
                        ),
                      )
                    : const Text("Login")),
            TextButton(
              onPressed: () {
                authProvider.isLoginPage = false;
                authProvider.notify();
              },
              child: const Text('Register ?'),
            ),
            SizedBox(
              height: Screen.height(context) * 4,
            ),
          ],
        ),
      ),
    );
  }
}
