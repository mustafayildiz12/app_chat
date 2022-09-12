import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/user_provider.dart';
import 'all_users_page/all_users_page.dart';
import 'profile_page/profile_page.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
   int _selectedIndex = 0;

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

   static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      
    ),
    AllUsersPage(),
   ProfilePage(),
   
  ];
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(child: _widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap:_onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.read_more),
          label: ""
          ),
           BottomNavigationBarItem(icon: Icon(Icons.abc_sharp),label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.tab_outlined),label: ""),
            
        ],
      ),
    );
  }
}


/*
Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingButton(
                onPressed: () async {
                  print(userProvider.usermodel);
                },
                title: "Print"),
            const SizedBox(
              height: 20,
            ),
            LoadingButton(
                onPressed: () async {
                  UserService().logout(context);
                },
                title: "LogOut")
          ],
        ),
      ),
 */