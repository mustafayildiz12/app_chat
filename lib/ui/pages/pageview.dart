import 'package:app_chat/core/class/screen_class.dart';
import 'package:app_chat/ui/pages/login_page.dart';
import 'package:app_chat/ui/pages/register_page.dart';
import 'package:flutter/material.dart';

class PageViewNavPage extends StatefulWidget {
  const PageViewNavPage({Key? key}) : super(key: key);

  @override
  State<PageViewNavPage> createState() => _PageViewNavPageState();
}

class _PageViewNavPageState extends State<PageViewNavPage> {
  final PageController _pageController = PageController();
  int currentPageValue = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPageValue == 0 ? "Register" : "Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Screen.height(context)*60,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (v) {
                    setState(() {
                      currentPageValue = v;
                    });
                  },
                  itemBuilder: ((context, index) {
                    if (index == 0) {
                      return RegisterPage(pageController: _pageController);
                    } else {
                      return LoginPage(pageController: _pageController);
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
