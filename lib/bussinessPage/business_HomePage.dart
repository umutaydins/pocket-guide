import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_guide/bussinessPage/commentPage.dart';
import 'package:pocket_guide/bussinessPage/eventPage.dart';
import 'package:pocket_guide/bussinessPage/postPage.dart';
import 'package:pocket_guide/components/colors.dart';

class BusinessHomePage extends StatefulWidget {
  const BusinessHomePage({Key? key}) : super(key: key);

  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _profileImageUrl = '';
  String _businessName = '';
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PostPage(),
    EventPage(),
    CommentPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchBusinessData() async {
    final userDoc = await _firestore
        .collection('businesses')
        .doc(_auth.currentUser!.uid)
        .get();
    final businessData = userDoc.data();
    print('aa');
    if (businessData != null) {
      setState(() {
        _profileImageUrl = businessData['profile_picture'] ?? '';
        _businessName = businessData['name'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: 393,
                  height: 292,
                  color: MyColors.thirdTextColor,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 105,
                        right: 198,
                        child: Padding(
                          padding: const EdgeInsets.all(115.0),
                          child: CircleAvatar(
                            backgroundImage: _profileImageUrl.isNotEmpty
                                ? NetworkImage(_profileImageUrl)
                                : null,
                            radius: 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Jungle Burger',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: MyColors.thirdTextColor,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: 345,
                  height: 194,
                  color: MyColors.thirdTextColor,
                ),
                GNav(
                  backgroundColor: MyColors.backGroundkColor,
                  color: MyColors.whiteColor,
                  gap: 8,
                  activeColor: MyColors.whiteColor,
                  tabBackgroundColor: MyColors.primaryColor,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Posts',
                      textColor: MyColors.whiteColor,
                    ),
                    GButton(
                      icon: Icons.search,
                      text: 'Events',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Comments',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: _onItemTapped,
                ),
                Expanded(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
