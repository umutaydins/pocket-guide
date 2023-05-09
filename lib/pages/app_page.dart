import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppPage extends StatefulWidget {
  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar:bottomNavigationBar(),
      ),
    );
  }
}

bottomNavigationBar() {
  return BottomNavigationBar(
    items: items,
    type: BottomNavigationBarType.fixed,
  );
}
List<BottomNavigationBarItem> items =[
  BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/home.svg'),
      label: 'Home'),
  BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/explore.svg'),
      label: 'Explore',),
  BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/profile.svg'),
      label: 'Profile'),

];
