import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_guide/bussinessPage/edit_bussiness_profile.dart';
import 'package:pocket_guide/usersPages/user_edit_interests.dart';
import 'package:pocket_guide/usersPages/user_edit_profile.dart';
import 'package:pocket_guide/usersPages/user_edit_interests.dart';
import '../components/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late bool _isNotification = false;
  final user = FirebaseAuth.instance.currentUser!;
  String _profileImageUrl = '';
  String _nameSurname = '';
  String _email = '';

  Future<void> fetchUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final userData = userDoc.data();
    if (userData != null) {
      setState(() {
        _profileImageUrl = userData['profile_picture'] ?? '';
        _nameSurname = userData['name_surname'] ?? '';
        _email = userData['email'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

//upload profil image
// Future<void> uploadProfileImage() async {
//   final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);

//   if (pickedImage != null) {
//     final file = File(pickedImage.path);
//     final user = FirebaseAuth.instance.currentUser;
//     final storageRef = FirebaseStorage.instance.ref().child('profile_images/${user!.uid}.jpg');

//     await storageRef.putFile(file);

//     final downloadUrl = await storageRef.getDownloadURL();
//     setState(() {
//       _profileImageUrl = downloadUrl;
//     });
//   }
// }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
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
              //PROFIL YAZISI
              Text(
                'Profile',
                style: GoogleFonts.inter(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: MyColors.thirdTextColor,
                ),
              ),
              //PROFIL RESMI
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // CircleAvatar(
                    //   radius: 30.0,
                    //   backgroundImage: NetworkImage(
                    //     'https://example.com/profile-image.png',
                    //   ),
                    // ),

                    //for show profil image
                    // CircleAvatar(
                    //   radius: 30.0,
                    //   backgroundImage: _profileImageUrl.isNotEmpty
                    //       ? NetworkImage(_profileImageUrl)
                    //       : null,
                    // ),
                    CircleAvatar(
                      backgroundImage: _profileImageUrl.isNotEmpty
                          ? NetworkImage(_profileImageUrl)
                          : null,
                    ),
                    SizedBox(width: 13.0),
                    //USER BILGILERI
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameSurname,
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
                          //EDIT PROFILE ICONU
                          Padding(padding: EdgeInsets.only(right: 108)),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const UserEditProfile(),
                                ),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/arrow.svg',
                              height: 24,
                              width: 12,
                            ),
                          )
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
                      'Edit interests',
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
                          builder: (context) => const EditInterests(),
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
              //LOGOUT
              SizedBox(
                height: 23,
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
