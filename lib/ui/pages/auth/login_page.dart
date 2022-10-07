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
        decoration: BoxDecoration(
            color: Theme.of(context).iconTheme.color,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: Colors.grey.shade300),
                cursorColor: Colors.grey.shade300,
                initialValue: authProvider.email,
                onChanged: (v) {
                  authProvider.email = v;
                  authProvider.notify();
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.grey.shade300),
                  labelText: "Email",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                style: TextStyle(color: Colors.grey.shade300),
                cursorColor: Colors.grey.shade300,
                onChanged: (v) {
                  authProvider.password = v;
                  authProvider.notify();
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  labelText: "Password",
                ),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).bottomSheetTheme.backgroundColor)),
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
              child: Text(
                'Register ?',
                style: TextStyle(color: Colors.grey.shade300),
              ),
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
