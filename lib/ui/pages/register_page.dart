import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/repostiroy/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/register_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ValueNotifier<bool> isAvailable = ValueNotifier(false);

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isRegistering = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(12)),
          child: ValueListenableBuilder(
            builder: (context, value, child) {
              return Column(
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
                          suffixIcon: ValueListenableBuilder(
                            builder: (context, value, child) {
                              return IconButton(
                                  onPressed: () async {
                                    isLoading.value = true;
                                    await UserService().chechUsername(
                                        registerProvider.username!,
                                        context,
                                        isAvailable);
                                    isLoading.value = false;
                                  },
                                  icon: isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ));
                            },
                            valueListenable: isLoading,
                          ),
                          labelText: "Username",
                          border: const OutlineInputBorder()),
                    ),
                  ),
                  Visibility(
                    visible: isAvailable.value,
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
                        ValueListenableBuilder(
                          valueListenable: isRegistering,
                          builder: (context, value, child) {
                            return ElevatedButton(
                              onPressed: () async {
                                if (registerProvider.email == null ||
                                    registerProvider.password == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Fill all the infos'),
                                  ));
                                } else {
                                  isRegistering.value = true;
                                  await registerProvider.registerWithProvider(
                                      registerProvider.email!.trim(),
                                      registerProvider.password!.trim(),
                                      context);
                                  isRegistering.value = false;
                                }
                              },
                              child: isRegistering.value
                                  ? CircularProgressIndicator(
                                      color: Theme.of(context).indicatorColor,
                                    )
                                  : const Text("Register"),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      registerProvider.isLoginPage = true;
                      registerProvider.notify();
                    },
                    child: const Text("Already Have Account"),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 4,
                  ),
                ],
              );
            },
            valueListenable: isAvailable,
          )),
    );
  }
}
