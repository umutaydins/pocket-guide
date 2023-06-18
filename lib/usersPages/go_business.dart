import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pocket_guide/bussinessPage/commentPage.dart';
import 'package:pocket_guide/components/colors.dart';
import 'package:pocket_guide/usersPages/go_event_page.dart';
import 'package:pocket_guide/usersPages/go_post_page.dart';
import 'package:pocket_guide/usersPages/user_home_page.dart';

import '../bussinessPage/eventPage.dart';
import '../bussinessPage/postPage.dart';
import 'package:url_launcher/url_launcher.dart';




class GoBusinessHomePage extends StatefulWidget {
  final Business business;

  GoBusinessHomePage({required this.business, Key? key}) : super(key: key);

  @override
  State<GoBusinessHomePage> createState() => _GoBusinessHomePageState();
}

class _GoBusinessHomePageState extends State<GoBusinessHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;


  Business get business => widget.business;

  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();


  }

_launchURL() async {
  const url = 'https://goo.gl/maps/aZJg2Tj7xm9s6eDm7';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Site açılamadı: $url';
  }
}






  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
                    if (business.coverPhotos.isNotEmpty)
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: business.coverPhotos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 393,
                            height: 252,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    NetworkImage(business.coverPhotos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                                                print('profil');

                        },
                        
                      ),
                    if (business.coverPhotos.isEmpty)
                      Center(
                        child: Text('No cover images selected'),
                      ),
                      Positioned(
                        top: 68,
                        right: 200,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(115.0),
                            child: CircleAvatar(
                              backgroundImage: business.profile_image.isNotEmpty
                                  ? NetworkImage(business.profile_image)
                                  : null,
                              radius: 34,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: MyColors.whiteColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                business.name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: MyColors.thirdTextColor,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
            child: Text('Siteyi Aç'),
            onPressed: () {
              _launchURL();
            },
          ),
              Container(
                width: 345,
                height: 194,
                color: MyColors.thirdTextColor,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
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
                            )),
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
                            PostPage(
                              businessId: business.id,
                            ),
                            EventPage(
                              businessId: business.id,
                            ),
                            CommentPage(businessId: business.id,),
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
