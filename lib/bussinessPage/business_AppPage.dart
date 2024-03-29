import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_guide/bussinessPage/business_HomePage.dart';
import 'package:pocket_guide/bussinessPage/bussiness_profile_page.dart';
import 'package:pocket_guide/components/colors.dart';

import '../usersPages/user_expolere_page.dart';
import '../usersPages/user_home_page.dart';

class BusinessAppPage extends StatefulWidget {
  @override
  State<BusinessAppPage> createState() => _BusinessAppPageState();
}

class _BusinessAppPageState extends State<BusinessAppPage> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>
  [  BusinessHomePage(),
    BussinessProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: MyColors.backGroundkColor,
        bottomNavigationBar: Container(
          color: MyColors.backGroundkColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: GNav(
              backgroundColor: MyColors.backGroundkColor,
              color: MyColors.whiteColor,
              gap: 32,
              activeColor: MyColors.whiteColor,
              tabBackgroundColor:MyColors.primaryColor ,
                tabs: [
                  GButton(
                    icon: Icons.home,iconColor: MyColors.whiteColor,
                    text: 'Home',textColor: MyColors.whiteColor,
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