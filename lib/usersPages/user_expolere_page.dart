import 'package:flutter/material.dart';

import '../components/colors.dart';
import 'bussiness_listing.dart';
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Expanded(
              child: BusinessListingPage(),
            ),
          ]
        ),
      ),
    );
  }
}