import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_guide/components/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

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
          padding: const EdgeInsets.only(top: 16, left: 24),
          //63-47=16 47 safezone uzakligi
          child: ListView(
            children: [
              Row(
                children: [
                  Text(
                    'Hi Berkay',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: MyColors.thirdTextColor,
                    ),
                  ),
                  SizedBox(
                    width: 175,
                  ),
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage(
                      'https://example.com/profile-image.png',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Search',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: MyColors.thirdTextColor,
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    width: 344,
                    height: 48,
                    decoration: BoxDecoration(
                      color: MyColors.whiteColor,
                      border: Border.all(
                        width: 2,
                        color: MyColors.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16.36),
                        Icon(Icons.search),
                        Expanded(
                          child: TextField(
                            // burada text box içindeki metnin stilini belirleyebilirsiniz
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: MyColors.primaryColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 8,bottom: 5),
                              hintText: 'What are you looking for ?',
                              hintStyle: GoogleFonts.inter(
                                color: MyColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                children: [
                  Text(
                    'Featured',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: MyColors.thirdTextColor,
                    ),
                  ),
                  SizedBox(width: 173),
                  Container(
                    child: Text(
                      'See all',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (){

                      },
                      icon:
                      Icon(Icons.arrow_forward_ios,
                        color: MyColors.thirdTextColor,
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
