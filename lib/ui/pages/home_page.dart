import 'package:app_chat/core/provider/user_provider.dart';
import 'package:app_chat/ui/product/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [LoadingButton(onPressed: () async {
            print(userProvider.usermodel);
          }, title: "Print")],
        ),
      ),
    );
  }
}
