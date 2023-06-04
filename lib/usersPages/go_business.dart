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

class Post {
  final List<String> postPhotos;

  Post({
    required this.postPhotos,
  });
}

class Event {
  final List<String> eventPhotos;

  Event({
    required this.eventPhotos,
  });
}

class GoBusinessHomePage extends StatefulWidget {
  final Business business;

  GoBusinessHomePage({required this.business, Key? key}) : super(key: key);

  @override
  State<GoBusinessHomePage> createState() => _GoBusinessHomePageState();
}

class _GoBusinessHomePageState extends State<GoBusinessHomePage>
    with SingleTickerProviderStateMixin {
  late Post post;
  late TabController tabController;
  late List<Post> posts;
  late List<Event> events;


  Business get business => widget.business;

  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
    post = Post(postPhotos: []);
    getPosts().then((postList) {
      setState(() {
        posts = postList;
      }); // fetchBusinessData();
    });
    getEvents().then((eventList) {
      setState(() {
        events = eventList;
      }); // fetchBusinessData();
    });
  }
  

  Future<List<Post>> getPosts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('businesses').get();
    List<Post> postList = [];
    snapshot.docs.forEach((doc) {
      List<String> postPhotos = [];
      if (doc['post_photos'] != null && doc['post_photos'] is List) {
        postPhotos = List<String>.from(doc['post_photos']);
      }

      Post post = Post(
        postPhotos: postPhotos,
      );
      postList.add(post);
    });

    return postList;
  }

  Future<List<Event>> getEvents() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('businesses').get();
    List<Event> eventList = [];
    snapshot.docs.forEach((doc) {
      List<String> eventPhotos = [];
      if (doc['event_photos'] != null && doc['event_photos'] is List) {
        eventPhotos = List<String>.from(doc['event_photos']);
      }

      Event event = Event(
        eventPhotos: eventPhotos,
      );
      eventList.add(event);
    });

    return eventList;
  }
  // Future<List<Comment>> getComments() async {
  //   QuerySnapshot snapshot =
  //   await FirebaseFirestore.instance.collection('businesses').get();
  //   List<Comment> commentList = [];
  //   snapshot.docs.forEach((doc) {
  //     List<String> comments = [];
  //     if (doc['comments'] != null && doc['comments'] is List) {
  //       comments = List<String>.from(doc['comments']);
  //     }
  //
  //     Comment comment = Comment(
  //       comments: comments,
  //     );
  //     commentList.add(comment);
  //   });
  //
  //   return commentList;
  // }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Future<void> fetchBusinessData() async {
  //   final userDoc = await _firestore
  //       .collection('businesses')
  //       .doc(_auth.currentUser!.uid)
  //       .get();
  //   final businessData = userDoc.data();
  //
  //   if (businessData != null) {
  //     setState(() {
  //       _coverPhotos = (businessData['cover_photos'] as List<dynamic>)
  //           .map((coverPhotoPath) => PickedFile(coverPhotoPath))
  //           .toList();
  //       _profileImageUrl = businessData['profile_picture'] ?? '';
  //       _businessName = businessData['name'] ?? '';
  //
  //     });
  //   }
  //
  // }

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
                        },
                      ),
                    if (business.coverPhotos.isEmpty)
                      Center(
                        child: Text('No cover images selected'),
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
                            GoPostPage(
                              business: business,
                            ),
                            GoEventPage(
                              business: business,
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
