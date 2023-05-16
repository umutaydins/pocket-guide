import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_guide/components/colors.dart';
import 'package:pocket_guide/usersPages/user_profile_page.dart';

import '../explorepage/expolere_page.dart';
import '../homepage/home_page.dart';

class UserAppPage extends StatefulWidget {
  @override
  State<UserAppPage> createState() => _UserAppPageState();
}

class _UserAppPageState extends State<UserAppPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ExplorePage(),
    UserProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      bottomNavigationBar: Container(
        color: MyColors.backGroundkColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GNav(
            backgroundColor: MyColors.backGroundkColor,
            color: MyColors.whiteColor,
            gap: 8,
            activeColor: MyColors.whiteColor,
            tabBackgroundColor: MyColors.primaryColor,
            tabs: [
              GButton(
                icon: Icons.home,
                iconColor: MyColors.whiteColor,
                text: 'Home',
                textColor: MyColors.whiteColor,
              ),
              GButton(
                icon: Icons.search,
                text: 'Explore',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
