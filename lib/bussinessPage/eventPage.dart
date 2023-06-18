import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_guide/bussinessPage/createEventPage.dart';

import '../components/colors.dart';

class EventPage extends StatefulWidget {
  final String businessId;

  const EventPage({Key? key, required this.businessId}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late bool _isUserBusinessOwner;

  @override
  void initState() {
    super.initState();
    _isUserBusinessOwner = _auth.currentUser!.uid == widget.businessId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backGroundkColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            if (_isUserBusinessOwner)
              Container(
                width: 345,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateEvent()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: MyColors.whiteColor,
                  ),
                  child: Text(
                    '+ Yeni etkinlik oluştur',
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: MyColors.primaryColor,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 40,),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('event').
              where('business_id', isEqualTo: widget.businessId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Hata: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('Mevcut etkinlik bulunmamaktadır.'),
                  );
                }

                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data() as Map<String, dynamic>;

                      return Container(
                        color: MyColors.whiteColor,
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.containsKey('event_photo') && data['event_photo'] != null)
                              Image.network(
                                data['event_photo'],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                '${data['business_name']}',
                                style: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Açıklama: ${data['description']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Etkinlik Tarihi: ${data['event_date']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Fiyat: ${data['price']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text(
                                  'Başlangıç: ${data['start_time']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Text(
                                  'Bitiş: ${data['end_time']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Yer: ${data['location']}',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
