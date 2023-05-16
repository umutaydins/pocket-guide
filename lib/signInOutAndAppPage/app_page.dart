<<<<<<< HEAD:lib/pages/app_page.dart
import 'package:flutter/material.dart';
import 'package:pocket_guide/pages/profile_page.dart';
import 'package:pocket_guide/pages/search_page.dart';

import 'home_page.dart';
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_guide/components/colors.dart';

import '../explorepage/expolere_page.dart';
import '../homepage/home_page.dart';
import '../usersPages/profile_page.dart';
>>>>>>> dev:lib/signInOutAndAppPage/app_page.dart

class AppPage extends StatefulWidget {
  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
<<<<<<< HEAD:lib/pages/app_page.dart
  List pages = [
    const HomePage(),
    const SearchPage(),
    ProfilePage(),
  ];

  int selectedIndex = 0;
=======
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
>>>>>>> dev:lib/signInOutAndAppPage/app_page.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD:lib/pages/app_page.dart
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
=======
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
>>>>>>> dev:lib/signInOutAndAppPage/app_page.dart
    );
  }
}
