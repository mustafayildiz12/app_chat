import 'package:app_chat/ui/pages/auth/login_page.dart';
import 'package:app_chat/ui/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/class/screen_class.dart';
import '../../../core/provider/auth_provider.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({Key? key}) : super(key: key);

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authProvider.isLoginPage ? "Login" : "Register"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Screen.height(context) * 75,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  switchInCurve: Curves.easeInBack,
                  switchOutCurve: Curves.easeInBack.flipped,
                  child: authProvider.isLoginPage
                      ? const LoginPage()
                      : const RegisterPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
