import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/class/screen_class.dart';
import '../../../core/provider/auth_provider.dart';
import '../../../core/provider/register_provider.dart';
import '../../../core/repostiroy/user_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: registerProvider.username,
                onChanged: (v) {
                  registerProvider.username = v;
                  registerProvider.notify();
                },
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Username" : null,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                        onPressed: () async {
                          registerProvider.isCheckingUsername = true;
                          registerProvider.notify();
                          await UserService().chechUsername(
                            registerProvider.username!,
                            context,
                          );
                          registerProvider.isCheckingUsername = false;
                          registerProvider.notify();
                        },
                        icon: registerProvider.isCheckingUsername
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.check,
                                color: Colors.white,
                              )),
                    labelText: "Username",
                    border: const OutlineInputBorder()),
              ),
            ),
            Visibility(
              visible: registerProvider.isAvailable,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      initialValue: registerProvider.email,
                      onChanged: (v) {
                        registerProvider.email = v;
                        registerProvider.notify();
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
                        registerProvider.password = v;
                        registerProvider.notify();
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
                      if (registerProvider.email == null ||
                          registerProvider.password == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Fill all the infos'),
                        ));
                      } else {
                        registerProvider.isRegistering = true;
                        registerProvider.notify();
                        await registerProvider.registerWithProvider(
                            registerProvider.email!.trim(),
                            registerProvider.password!.trim(),
                            context);
                        registerProvider.isRegistering = false;
                        registerProvider.notify();
                      }
                    },
                    child: registerProvider.isRegistering
                        ? CircularProgressIndicator(
                            color: Theme.of(context).indicatorColor,
                          )
                        : const Text("Register"),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                authProvider.isLoginPage = true;
                authProvider.notify();
              },
              child: const Text("Already Have Account"),
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
