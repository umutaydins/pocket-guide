import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_guide/usersPages/user_profile_page.dart';

import '../components/colors.dart';
import '../signInOutAndAppPage/app_page.dart';

class UserEditProfile extends StatefulWidget {
  const UserEditProfile({Key? key}) : super(key: key);

  @override
  State<UserEditProfile> createState() => _UserEditProfileState();
}

class _UserEditProfileState extends State<UserEditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 18, left: 20),
          child: ListView(
            children: [
              editProfile(context),
              SizedBox(height: 16),
              changePhoto(context),
              SizedBox(height: 28),
              changeUsername(context),
              SizedBox(height: 25),
              changeEmail(context),
              SizedBox(height: 25),
              changePassword(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget editProfile(BuildContext context) {
  return Row(
    children: [
      IconButton(
        onPressed: () {
          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(),
            ),
          );
        },
        icon: Stack(
          children: [
            Container(
              child: SvgPicture.asset(
                'assets/icons/small_box.svg',
                color: MyColors.whiteColor,
                height: 32,
                width: 32,
              ),
            ),
            Positioned(
              left: 4,
              top: 4,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: MyColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
      Text(
        'Edit Profile',
        style: GoogleFonts.inter(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: MyColors.thirdTextColor,
        ),
      ),
    ],
  );
}

Widget changePhoto(BuildContext context) {
  return Center(
    child: Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change photo',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.settings_backup_restore_sharp,
                      color: MyColors.thirdTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget changeUsername(BuildContext context) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name and Surname',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: MyColors.thirdTextColor,
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Container(
                width: 348,
                height: 48,
                decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  border: Border.all(
                    width: 2,
                    color: MyColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // burada text box içindeki metnin stilini belirleyebilirsiniz
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                          hintText: 'Enter text here',
                          hintStyle: GoogleFonts.inter(
                            color: MyColors.secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Stack(
                        children: [
                          Container(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                MyColors.primaryColor.withOpacity(0.2),
                                BlendMode.srcIn,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/small_box.svg',
                                color: MyColors.primaryColor,
                                height: 32,
                                width: 32,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 7,
                            child: SvgPicture.asset(
                              'assets/icons/edit.svg',
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget changeEmail(BuildContext context) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-mail',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: MyColors.thirdTextColor,
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Container(
                width: 348,
                height: 48,
                decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  border: Border.all(
                    width: 2,
                    color: MyColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // burada text box içindeki metnin stilini belirleyebilirsiniz
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                          hintText: 'Enter text here',
                          hintStyle: GoogleFonts.inter(
                            color: MyColors.secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Stack(
                        children: [
                          Container(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                MyColors.primaryColor.withOpacity(0.2),
                                BlendMode.srcIn,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/small_box.svg',
                                color: MyColors.primaryColor,
                                height: 32,
                                width: 32,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 7,
                            child: SvgPicture.asset(
                              'assets/icons/edit.svg',
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget changePassword(BuildContext context) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Password',
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: MyColors.thirdTextColor,
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Container(
                width: 348,
                height: 48,
                decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  border: Border.all(
                    width: 2,
                    color: MyColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // burada text box içindeki metnin stilini belirleyebilirsiniz
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                          hintText: 'Enter new password',
                          hintStyle: GoogleFonts.inter(
                            color: MyColors.secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Stack(
                        children: [
                          Container(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                MyColors.primaryColor.withOpacity(0.2),
                                BlendMode.srcIn,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/small_box.svg',
                                color: MyColors.primaryColor,
                                height: 32,
                                width: 32,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 7,
                            child: SvgPicture.asset(
                              'assets/icons/edit.svg',
                              color: MyColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
