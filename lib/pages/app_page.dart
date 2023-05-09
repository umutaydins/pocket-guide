import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_guide/colors.dart';

class AppPage extends StatefulWidget {
  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.backGroundkColor,
        bottomNavigationBar: bottomNavigationBar(),
    );
  }
  bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: MyColors.primaryColor,
      backgroundColor: MyColors.backGroundkColor,
      unselectedItemColor: MyColors.whiteColor,
      elevation: 0,
      onTap: (int index) {
        if(index == 0){
          setState(() {
            _currentIndex = index;
          });
        }else if(index==1){
          setState(() {
            _currentIndex = index;
          });
        }else if(index==2){
          setState(() {
            _currentIndex = index;
          });
        }
      },
      selectedFontSize: 10,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      items: items,
      type: BottomNavigationBarType.fixed,
    );
  }


  List<BottomNavigationBarItem> items =[
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/home.svg'),
      label: 'Home',),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/explore.svg'),
      label: 'Explore',),
    BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/icons/profile.svg'),
        label: 'Profile'),
  ];
}


