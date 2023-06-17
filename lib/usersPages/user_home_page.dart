import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_guide/components/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bussinessPage/business_HomePage.dart';
import 'bussiness_searchbar.dart';
import 'go_business.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class Business {
  final String name;
  final String profile_image;
  final List<String> coverPhotos;

  final String id;

  Business({
    required this.name,
    required this.profile_image,
    required this.coverPhotos,
    required this.id,
  });
}

class Event {

  final String eventPhoto;
  final String businessId;

  Event({

    required this.eventPhoto,
    required this.businessId,
  });
}



class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Business> businesses = [];
  late bool _isNotification = false;
  String _profileImageUrl = '';
  String _nameSurname = '';
  String _email = '';
  List<Event> events = [];

  Future<List<Event>> getEvents() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('event').get();

    List<Event> eventList = [];
    snapshot.docs.forEach((doc) {
      String businessId = doc['businness_id'];
      String eventPhoto = doc['event_photo'];

      Event event = Event(
        businessId: businessId,
        eventPhoto: eventPhoto,
      );
      eventList.add(event);
    });

    return eventList;
  }


  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

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

    // İşletmeleri getir ve listeyi güncelle
    getBusinesses().then((businessList) {
      setState(() {
        businesses = businessList;
      });
    });
    getEvents().then((eventList) {
      setState(() {
        events = eventList;
      });
    });
  }

  // Future<void> fetchBusinesses() async {
  //   List<Business> businessList = await getBusinesses();
  //   setState(() {
  //     businesses = businessList;
  //   });
  // }
  Future<List<Business>> getBusinesses() async {
    // Firebase'den işletme bilgilerini getir
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('businesses').get();

    // QuerySnapshot'tan işletme listesini oluştur
    List<Business> businessList = [];
    snapshot.docs.forEach((doc) async {
      String name = doc['name'];
      String imageUrl = doc['profile_picture'];
      String id = doc.id;

      List<String> coverPhotos = [];
      if (doc['cover_photos'] != null && doc['cover_photos'] is List) {
        coverPhotos = List<String>.from(doc['cover_photos']);
      }
      // List<String> postPhotos = [];
      // if (doc['post_photos'] != null && doc['post_photos'] is List) {
      //   postPhotos =
      //       await Future<List<String>>.delayed(Duration(seconds: 0), () {
      //     return List<String>.from(doc['post_photos']);
      //   });
      // }


      Business business = Business(
        name: name,
        profile_image: imageUrl,
        coverPhotos: coverPhotos,
        // postPhotos: postPhotos,
        id: id,
      );
      businessList.add(business);
    });

    return businessList;
  }

  @override
  Widget build(BuildContext context) {
    if (businesses == null) {
      // Loading durumunu göstermek için bir widget döndürebilirsiniz
      return CircularProgressIndicator();
    } else if (businesses.isEmpty) {
      // İşletme listesi boş ise ilgili durumu göstermek için bir widget döndürebilirsiniz
      return Text('İşletme bulunamadı');
    } else {
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
                      'Hi ' + _nameSurname,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 70.0, right: 1),
                      child: CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(
                          _profileImageUrl,
                        ),
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
                                    EdgeInsets.only(left: 8, bottom: 5),
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: businesses
                        .map((business) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoBusinessHomePage(
                                    business: business,
                                  ),
                                  settings: RouteSettings(arguments: business),
                                ),
                              );
                              print('Kutuya tıklandı!');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 173,
                                height: 170,
                                color: MyColors.whiteColor,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: MyColors.backGroundkColor,
                                      ),
                                      width: double.infinity,
                                      height: 85,
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 85,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(business.profile_image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 70,
                                      bottom: 10,
                                      child: Text(
                                        business.name,
                                        style: TextStyle(
                                          color: MyColors.backGroundkColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          );
                        })
                        .take(5) // Limit to only 5 items
                        .toList(),
                  ),
                ),
                SizedBox(height: 35,),
                Row(
                  children: [
                    Text(
                      'Events',
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: MyColors.thirdTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: events
                        .map((event) {
                      Business correspondingBusiness = businesses.firstWhere((business) => business.id == event.businessId);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoBusinessHomePage(
                                business: correspondingBusiness,
                              ),
                            ),
                          );
                          print('Etkinliğe tıklandı!');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: 173,
                            height: 170,
                            color: MyColors.whiteColor,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: MyColors.backGroundkColor,
                                  ),
                                  width: double.infinity,
                                  height: 85,
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 85,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(event.eventPhoto),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 70,
                                  bottom: 10,
                                  child: Text(
                                    correspondingBusiness.name,
                                    style: TextStyle(
                                      color: MyColors.backGroundkColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                        .take(5)
                        .toList(),
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }
  }
}
