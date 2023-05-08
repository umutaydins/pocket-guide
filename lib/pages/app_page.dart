import 'package:flutter/material.dart';
import 'package:pocket_guide/pages/profile_page.dart';
import 'package:pocket_guide/pages/search_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_page.dart';

class AppPage extends StatefulWidget {
  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  List pages = [
     HomePage(),
     SearchPage(),
     ProfilePage(),
  ];

  int selectedIndex= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 57,
        backgroundColor : Color(0xFF222831),
        destinations: [
          NavigationDestination(icon: SvgPicture.asset('assets/icons/home.svg'), label: 'Home'),
          NavigationDestination(icon: SvgPicture.asset('assets/icons/explore.svg'), label: 'Explore'),
          NavigationDestination(icon: SvgPicture.asset('assets/icons/profile.svg'), label: 'Profile'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value){
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
