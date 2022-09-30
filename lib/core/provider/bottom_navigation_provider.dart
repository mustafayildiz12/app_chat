import 'package:flutter/cupertino.dart';

import '../../ui/pages/bottoms/all_users_page/all_users_page.dart';
import '../../ui/pages/bottoms/premium_page/bee_premium_page.dart';
import '../../ui/pages/bottoms/profile_page/profile_page.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int selectedIndex = 0;

     final List<Widget> widgetOptions = <Widget>[
   const BeePremiumPage(),
    const AllUsersPage(),
    const ProfilePage(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notify();
  }

  void notify() {
    notifyListeners();
  }
}
