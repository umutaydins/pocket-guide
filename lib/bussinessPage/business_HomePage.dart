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
import 'package:url_launcher/url_launcher.dart';

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
  String _description = '';
  String _openFrom = '';
  String _location = '';
  String _price = '';
  String _selectedTags = '';
  String _selectedOptions = '';
    double _totalRating = 0.0; // Total rate

  // Map<String, bool> selectedPricing = {};

  void initState() {
    tabController = TabController(length: 3, vsync: this);
    fetchBusinessData();
        fetchTotalRating(); // Fetch total rating value

    // fetchPricing();

    super.initState();
  }

 // Fetch total rating value
  Future<void> fetchTotalRating() async {
    final businessDoc = await _firestore
        .collection('businesses')
        .doc(_auth.currentUser!.uid)
        .get();
    final businessData = businessDoc.data();

    if (businessData != null) {
      final totalRating = businessData['totalRating'] ?? 0.0;
      setState(() {
        _totalRating = totalRating.toDouble();
      });
    }
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  String _formatTags(String tags) {
    List<String> tagList = tags.split(',');

    if (tagList.length <= 2) {
      return tags;
    }

    String firstPart = tagList.sublist(0, 1).join(',');
    String secondPart = tagList.sublist(1).join(', ');

    return '$firstPart,\n$secondPart';
  }

  String _Formatoptions(String options) {
    List<String> tagList = options.split(',');

    if (tagList.length <= 1) {
      return options;
    }

    String firstPart = tagList.sublist(0, 1).join(',');
    String secondPart = tagList.sublist(1).join(', ');

    return '$firstPart,\n$secondPart';
  }

  // void fetchPricing() async {
  //   DocumentSnapshot doc = await _firestore
  //       .collection('businesses')
  //       .doc(_auth.currentUser!.uid)
  //       .get();
  //   Map<String, dynamic> pricing = Map<String, dynamic>.from(doc['pricing']);
  //   Map<String, bool> convertedPricing =
  //       pricing.map((key, value) => MapEntry(key, value));
  //   setState(() {
  //     selectedPricing = convertedPricing;
  //     print('price');
  //     print(selectedPricing);
  //   });
  // }
  _launchURL() async {
    final url = _location.replaceAll('"', '');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Site açılamadı: $url';
    }
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
        _price = businessData['price'] ?? '';
        _selectedTags = businessData['selectedTags'] ?? '';
        _selectedOptions = businessData['selectedOptions'] ?? '';
        _location = businessData['location'] ?? '';
        _description = businessData['description'] ?? '';
        _openFrom = businessData['openFrom'] ?? '';

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
                    Positioned(
                      top: 68,
                      right: 200,
                      child: Container(
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
              SizedBox(height: 12,),
              Text(_description,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: MyColors.secondaryTextColor,
                ),),
               Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Text(
                                'Price ranges',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.secondaryTextColor,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(_price,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: MyColors.thirdTextColor,
                                ),),
                            ],
                          ),
                          SizedBox(width: 152),
                          Column(
                            children: [
                              Text(
                                'Interests' ,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.secondaryTextColor,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(_formatTags(_selectedTags) +' ',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.thirdTextColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 23),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Text('Open From',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.secondaryTextColor,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(_openFrom,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.thirdTextColor,
                                ),),
                            ],
                          ),
                          SizedBox( width: 162,),
                          Column(
                            children: [
                              Text(
                                'Options' ,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.secondaryTextColor,
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text(_Formatoptions(_selectedOptions),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: MyColors.thirdTextColor,
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [

                        TotalRatingWidget(totalRating: _totalRating), // Added TotalRatingWidget
                                                SizedBox(width: 140,),

                          
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(MyColors.primaryColor), // Set the button background color
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0), // Set the button border radius
                                ),
                              ),
                            ),
                            onPressed: _launchURL,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [ 
                                Icon(Icons.location_on_outlined), // Add the icon to the left of the text
                                SizedBox(width: 8.0), // Add spacing between the icon and text
                                Text('Location'), // Button text
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),


              // PricingWidget(pricing: selectedPricing),
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
                              businessId: _auth.currentUser!.uid,
                            ),
                            EventPage(
                              businessId: _auth.currentUser!.uid,
                            ),
                            CommentPage(
                              businessId: _auth.currentUser!.uid,
                            ),
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

class PricingWidget extends StatelessWidget {
  final Map<String, bool> pricing;

  const PricingWidget({required this.pricing});

  @override
  Widget build(BuildContext context) {
    String priceText = '';
    if (pricing['cheap'] == true) {
      priceText = '\$';
    } else if (pricing['standard'] == true) {
      priceText = '\$\$';
    } else if (pricing['expensive'] == true) {
      priceText = '\$\$\$';
    }
    print('sdsda');
    print(priceText);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priceText,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
class TotalRatingWidget extends StatelessWidget {
  final double totalRating;

  const TotalRatingWidget({required this.totalRating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        SizedBox(width: 4),
        Text(
          totalRating.toStringAsFixed(1),

          style: TextStyle(
            color:MyColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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