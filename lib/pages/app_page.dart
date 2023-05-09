import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_guide/colors.dart';

class AppPage extends StatefulWidget {
  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: MyColors.backGroundkColor,
        bottomNavigationBar: Container(
          color: MyColors.backGroundkColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            child: GNav(
              backgroundColor: MyColors.backGroundkColor,
              color: MyColors.whiteColor,
              gap: 8,
              activeColor: MyColors.whiteColor,
              tabBackgroundColor:MyColors.primaryColor ,
                tabs: [
                  GButton(
                    icon: Icons.home,iconColor: MyColors.whiteColor,
                    text: 'Home',textColor: MyColors.whiteColor,
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
            ),
          ),
        ),
    );
  }
}


