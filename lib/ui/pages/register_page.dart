import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/core/repostiroy/user_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/provider/register_provider.dart';

class RegisterPage extends StatefulWidget {
  final PageController pageController;

  const RegisterPage({required this.pageController, Key? key})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ValueNotifier<bool> isAvailable = ValueNotifier(false);

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool isValid = false;

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
                            onChanged: (v) {
                              registerProvider.email = v;
                              registerProvider.notify();
                              isValid = EmailValidator.validate(v);
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
                                if (isValid) {
                                  await registerProvider.registerWithProvider(
                                      registerProvider.email!.trim(),
                                      registerProvider.password!.trim(),
                                      context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('wrong email format'),
                                  ));
                                }
                              }
                            },
                             child: const Text("Register"),),
                      ],
                    ),
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
