import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/bussinessPage/commentPage.dart';
import 'package:pocket_guide/bussinessPage/eventPage.dart';
import 'package:pocket_guide/bussinessPage/postPage.dart';
import 'package:pocket_guide/components/colors.dart';

class BusinessHomePage extends StatefulWidget {
  const BusinessHomePage({Key? key}) : super(key: key);

  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}


class _BusinessHomePageState extends State<BusinessHomePage>
    with SingleTickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _profileImageUrl = '';
  String _businessName = '';
  late TabController tabController;
  List<PickedFile> _coverPhotos = [];




  void initState() {
    tabController = TabController(length: 3, vsync: this);
    fetchBusinessData();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }



  Future<void> fetchBusinessData() async {
    final userDoc = await _firestore
        .collection('businesses')
        .doc(_auth.currentUser!.uid)
        .get();
    final businessData = userDoc.data();

    if (businessData != null) {
      setState(() {
        _coverPhotos = (businessData['cover_photos'] as List<dynamic>)
            .map((coverPhotoPath) => PickedFile(coverPhotoPath))
            .toList();
        _profileImageUrl = businessData['profile_picture'] ?? '';
        _businessName = businessData['name'] ?? '';

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: 393,
                  height: 252,
                  color: MyColors.thirdTextColor,
                  child: Stack(
                    children: [
                      if (_coverPhotos.isNotEmpty)
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _coverPhotos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 393,
                              height: 252,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(_coverPhotos[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      if (_coverPhotos.isEmpty)
                        Center(
                          child: Text('No cover images selected'),
                        ),
                    ],

                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  _businessName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: MyColors.thirdTextColor,
                  ),
                ),

                Container(
                  width: 345,
                  height: 194,
                  color: MyColors.backGroundkColor,
                   child:Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text('Price ranges',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: MyColors.thirdTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 112),
                              Text('Interests',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.thirdTextColor,
                                ),
                              ),
                            ],
                          ),
                         SizedBox(height: 23),
                         Text('Interests',
                           style: GoogleFonts.inter(
                             fontWeight: FontWeight.w400,
                             fontSize: 12,
                             color: MyColors.thirdTextColor,
                           ),
                         ),
                       ],
                     ),
                   ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: MyColors.backGroundkColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 55),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.backGroundkColor,
                            borderRadius: BorderRadius.circular(48),
                            border: Border.all(
                              color: MyColors.thirdTextColor,
                              width: 1,
                            )
                          ),
                          child: TabBar(
                            indicatorWeight: 1,
                            labelColor: MyColors.thirdTextColor,
                            controller: tabController,
                            indicator: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(48),
                              border: Border.all(
                                width: 2,
                              ),
                            ),
                            tabs: [
                              Tab(
                                text: 'Posts',
                              ),
                              Tab(
                                text: 'Events',
                              ),
                              Tab(
                                text: 'Comments',
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        child: Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              PostPage(),
                              EventPage(),
                              CommentPage(businessId:_auth.currentUser!.uid ,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}


// static List<Widget> _widgetOptions = <Widget>[
//   PostPage(),
//   EventPage(),
//   CommentPage(),
// ];
//
// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });
// }

//_widgetOptions.elementAt(_selectedIndex),
// GNav(
//   backgroundColor: MyColors.backGroundkColor,
//   color: MyColors.whiteColor,
//   gap: 8,
//   activeColor: MyColors.whiteColor,
//   tabBackgroundColor: MyColors.primaryColor,
//   tabs: [
//     GButton(
//       icon: Icons.home,
//       text: 'Posts',
//       textColor: MyColors.whiteColor,
//     ),
//     GButton(
//       icon: Icons.search,
//       text: 'Events',
//     ),
//     GButton(
//       icon: Icons.person,
//       text: 'Comments',
//     ),
//   ],
//   selectedIndex: _selectedIndex,
//   onTabChange: _onItemTapped,
// ),
// Expanded(
//   child: _widgetOptions.elementAt(_selectedIndex),
// ),


// Positioned(
//   top: 105,
//   right: 198,
//   child: Padding(
//     padding: const EdgeInsets.all(115.0),
//     child: CircleAvatar(
//       backgroundImage: _profileImageUrl.isNotEmpty
//           ? NetworkImage(_profileImageUrl)
//           : null,
//       radius: 34,
//     ),
//   ),
// ),
