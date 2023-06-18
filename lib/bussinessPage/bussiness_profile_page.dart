import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocket_guide/bussinessPage/bussines_edit_interests.dart';
import '../components/colors.dart';

class BussinessProfilePage extends StatefulWidget {
  const BussinessProfilePage({Key? key}) : super(key: key);

  @override
  _BussinessProfilePageState createState() => _BussinessProfilePageState();
}

class _BussinessProfilePageState extends State<BussinessProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late bool _isNotification = false;


  // String _profileImageUrl = '';
  String _businessName = '';
  String _email = '';
  String _profileImageUrl = '';

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
        _email = businessData['email'] ?? '';

      });
    }
  }
  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 18, left: 24),
          child: ListView(
            children: [
              Text(
                'Profile',
                style: GoogleFonts.inter(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.thirdTextColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                            backgroundImage: _profileImageUrl.isNotEmpty
                                ? NetworkImage(_profileImageUrl)
                                : null,
                            radius: 34,
                          ),
                    SizedBox(width: 13.0),

                    //Bussiness information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _businessName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: MyColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _email,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: MyColors.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //SETTINGS YAZISI
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 42),
                  child: Text(
                    'Settings',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: MyColors.thirdTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 23,
              ),
              //NOTIFICATIONS
              Row(
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    color: MyColors.whiteColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Notifications',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                        activeColor: MyColors.primaryColor,
                        value: _isNotification,
                        onChanged: (bool newNotification) {
                          setState(() {
                            _isNotification = newNotification;
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 33,
              ),
              //EDIT INTERESTS

              //LOGOUT
              SizedBox(
                height: 23,
              ),
                  Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/small_box.svg',
                    color: MyColors.whiteColor,
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Edit interests and options',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 188)),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  EditBusinessInterestPage(),
                        ),
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      height: 18,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: MyColors.errorColor,
                  ),
                  TextButton(
                    onPressed: signUserOut,
                    child: Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: MyColors.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
