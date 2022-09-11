import 'package:app_chat/ui/product/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/register_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Column(
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
              style: style,
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
              style: style,
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
              style: style,
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
              title: "Register")
        ],
      ),
    );
  }
}

/*
  if (_formKey.currentState!.validate()) {
                        await UserService().register(
                            email: registerProvider.email.toString(),
                            password: registerProvider.password.toString());
                      }
 */
