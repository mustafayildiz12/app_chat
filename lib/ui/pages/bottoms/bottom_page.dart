import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/provider/bottom_navigation_provider.dart';

class BottomPage extends StatelessWidget {
  const BottomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomNavigationProvider bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context);
    return Scaffold(
      body: Center(
          child: bottomNavigationProvider
              .widgetOptions[bottomNavigationProvider.selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: bottomNavigationProvider.onItemTapped,
        currentIndex: bottomNavigationProvider.selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.money_sharp), label: "Premium"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
