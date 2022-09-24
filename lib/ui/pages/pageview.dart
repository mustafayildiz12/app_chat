import 'package:app_chat/ui/pages/login_page.dart';
import 'package:app_chat/ui/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/class/screen_class.dart';
import '../../core/provider/auth_provider.dart';

class PageViewNavPage extends StatefulWidget {
  const PageViewNavPage({Key? key}) : super(key: key);

  @override
  State<PageViewNavPage> createState() => _PageViewNavPageState();
}

class _PageViewNavPageState extends State<PageViewNavPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authProvider.isLoginPage ? "Register" : "Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Screen.height(context) * 60,
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
