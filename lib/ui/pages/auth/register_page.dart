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
            color: Theme.of(context).iconTheme.color,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                style: TextStyle(color: Colors.grey.shade300),
                cursorColor: Colors.grey.shade300,
                initialValue: registerProvider.username,
                onChanged: (v) {
                  registerProvider.username = v;
                  registerProvider.notify();
                },
                validator: (value) =>
                    (value!.isEmpty) ? "Please Enter Username" : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey.shade300,
                  ),
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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.check,
                              color: Colors.white,
                            )),
                  labelText: "Username",
                ),
              ),
            ),
            Visibility(
              visible: registerProvider.isAvailable,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey.shade300),
                      cursorColor: Colors.grey.shade300,
                      initialValue: registerProvider.bio,
                      onChanged: (v) {
                        registerProvider.bio = v;
                        registerProvider.notify();
                      },
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.text_format,color: Colors.grey.shade300),
                        labelText: "Bio",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey.shade300),
                      cursorColor: Colors.grey.shade300,
                      initialValue: registerProvider.email,
                      onChanged: (v) {
                        registerProvider.email = v;
                        registerProvider.notify();
                      },
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.email,color: Colors.grey.shade300),
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
                        registerProvider.password = v;
                        registerProvider.notify();
                      },
                      obscureText: true,
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.lock,color: Colors.grey.shade300,),
                        labelText: "Password",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context)
                                .bottomSheetTheme
                                .backgroundColor)),
                    onPressed: () async {
                      if (registerProvider.email == null ||
                          registerProvider.password == null ||
                          registerProvider.bio == null) {
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
                            color: Colors.grey.shade300,
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
              child: Text(
                "Already Have Account",
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
